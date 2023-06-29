//
//  KeywordsPostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxSwift
import RxRelay

final class PostsViewController: RxBaseViewController<PostsViewModel> {

    private var posts: [PostDTO]?
    private var isScrapPostsList: [Bool]?
    private var isNavigationBarHidden = true
    
    private let postsView = PostsView()
    
    init(
        viewModel: PostsViewModel,
        isNavigationBarHidden: Bool
    ) {
        super.init(viewModel: viewModel)
        self.isNavigationBarHidden = isNavigationBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNavigationBarHidden == false {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    override func render() {
        self.view = postsView
    }
    
    override func bind(viewModel: PostsViewModel) {
        postsView.postsTableView.dataSource = self
        postsView.postsTableView.delegate = self
        bindOutput(viewModel)
        
        postsView.postsTableView.rx.contentOffset
            .filter { contentOffset in
                return contentOffset.y < -30
            }
            .map { _ in () }
            .bind(to: viewModel.tableViewReload)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: PostsViewModel) {
        viewModel.postsListOutput
            .asDriver(onErrorJustReturn: [PostDTO]())
            .drive(onNext: { [weak self] post in
                self?.posts = post
                self?.postsView.postsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.postsListDidScrapOutput
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] isScrapList in
                self?.isScrapPostsList = isScrapList
            })
            .disposed(by: disposeBag)

        viewModel.isPostsEmptyOutput
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] isEmpty in
                if isEmpty {
                    self?.postsView.keywordsPostsViewExceptionView.isHidden = false
                } else {
                    self?.postsView.keywordsPostsViewExceptionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollToTop),
            name: Notification.Name("scrollToTop"),
            object: nil
        )
    }
    
    @objc
    private func scrollToTop() {
        postsView.postsTableView.setContentOffset(.zero, animated: true)
    }
}

extension PostsViewController: PostScrapButtonDidTapped {
    func scrapButtonDidTapped(
        storagePost: StoragePost,
        isScrapped: Bool,
        cellIndex: Int
    ) {
        isScrapPostsList?[cellIndex] = isScrapped
        // MARK: - fix me, viewModel 주입 방법 수정
        
        let viewModel = PostsViewModel(viewType: .keyword)
        viewModel.cellScrapButtonDidTap.accept((storagePost, isScrapped))
    }
}

extension PostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let index = indexPath.section
        cell.cellDelegate = self
        cell.cellIndex = index
        if let data = posts?[index] {
            cell.binding(model: data)
            if let isUnique = isScrapPostsList?[index] {
                if isUnique {
                    cell.isTapped = false
                } else {
                    cell.isTapped = true
                }
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textNum = posts?[indexPath.section].summary?.count ?? 0
        if posts?[indexPath.section].img ?? String() == TextLiterals.noneText {
            switch textNum {
            case 0...50: return SizeLiterals.postCellSmall
            case 51...80: return SizeLiterals.postCellMedium
            case 81...100: return SizeLiterals.postCellLarge
            default: return SizeLiterals.postCellLarge
            }
        } else {
            return SizeLiterals.postCellXLarge
        }
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? PostsTableViewCell else { return }
        let index = indexPath.section
        let storagePost = StoragePost(
            img: posts?[index].img,
            name: posts?[index].name,
            summary: posts?[index].summary,
            title: posts?[index].title,
            url: posts?[index].url
        )
        
        let webViewModel = WebViewModel(url: selectedCell.url)
        webViewModel.postWriter = posts?[index].name
        webViewModel.storagePost = storagePost
        
        let webViewController = WebViewController(viewModel: webViewModel)
        webViewController.isPostWebView = true
        if let isScrapped = isScrapPostsList?[index] {
            webViewController.setScrapButton(didScrap: !isScrapped)
        }
        webViewController.postData = storagePost
        
        self.navigationController?.pushViewController(webViewController, animated: true)
        
        webViewController.didScrapClosure = { [weak self] didScrap in
            self?.isScrapPostsList?[index] = !didScrap
            selectedCell.isTapped = didScrap
            if didScrap {
                selectedCell.scrapButton.setImage(ImageLiterals.saveBookMarkIcon, for: .normal)
            } else {
                selectedCell.scrapButton.setImage(ImageLiterals.unSaveBookMarkIcon, for: .normal)
            }
        }
    }
}
