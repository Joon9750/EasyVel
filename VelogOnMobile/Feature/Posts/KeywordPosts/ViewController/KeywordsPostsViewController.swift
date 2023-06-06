//
//  KeywordsPostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxSwift
import RxRelay

final class KeywordsPostsViewController: RxBaseViewController<KeywordsPostsViewModel> {
    
    private let keywordsPostsView = KeywordsPostsView()
    private var isScrolled: Bool = false
    private var keywordsPosts: GetTagPostResponse?
    private var isScrapPostsList: [Bool]?
    
    override func render() {
        self.view = keywordsPostsView
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func bind(viewModel: KeywordsPostsViewModel) {
        keywordsPostsView.keywordsTableView.dataSource = self
        keywordsPostsView.keywordsTableView.delegate = self
        bindOutput(viewModel)
        
        keywordsPostsView.keywordsTableView.rx.contentOffset
            .filter { contentOffset in
                return contentOffset.y < -30
            }
            .map { _ in () }
            .bind(to: viewModel.tableViewReload)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: KeywordsPostsViewModel) {
        viewModel.tagPostsListOutput
            .asDriver(onErrorJustReturn: GetTagPostResponse(tagPostDtoList: [TagPostDtoList]()))
            .drive(onNext: { [weak self] post in
                self?.keywordsPosts = post
                self?.keywordsPostsView.keywordsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.tagPostsListDidScrapOutput
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] isScrapList in
                self?.isScrapPostsList = isScrapList
            })
            .disposed(by: disposeBag)

        viewModel.isPostsEmptyOutput
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] isEmpty in
                if isEmpty {
                    self?.keywordsPostsView.keywordsPostsViewExceptionView.isHidden = false
                } else {
                    self?.keywordsPostsView.keywordsPostsViewExceptionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func scrollToTop() {
        keywordsPostsView.keywordsTableView.setContentOffset(CGPoint(x: 0, y: -1), animated: true)
    }
}

extension KeywordsPostsViewController: PostScrapButtonDidTapped {
    func scrapButtonDidTapped(
        storagePost: StoragePost,
        isScrapped: Bool
    ) {
        // MARK: - fix me, viewModel 주입 방법 수정
        let viewModel = KeywordsPostsViewModel()
        viewModel.cellScrapButtonDidTap.accept((storagePost, isScrapped))
    }
}

extension KeywordsPostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return keywordsPosts?.tagPostDtoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KeywordsTableViewCell.identifier, for: indexPath) as? KeywordsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let index = indexPath.section
        cell.cellDelegate = self
        if let data = keywordsPosts?.tagPostDtoList?[index] {
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
        let textNum = keywordsPosts?.tagPostDtoList?[indexPath.section].summary?.count ?? 0
        if keywordsPosts?.tagPostDtoList?[indexPath.section].img ?? String() == TextLiterals.noneText {
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

extension KeywordsPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! KeywordsTableViewCell
        let webViewModel = WebViewModel(url: selectedCell.url)
        let webViewController = WebViewController(viewModel: webViewModel)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.section
        let swipeAction = UIContextualAction(style: .normal, title: "스크랩", handler: { [weak self] action, view, completionHaldler in
            let post = StoragePost(
                img: self?.keywordsPosts?.tagPostDtoList?[index].img,
                name: self?.keywordsPosts?.tagPostDtoList?[index].name,
                summary: self?.keywordsPosts?.tagPostDtoList?[index].summary,
                title: self?.keywordsPosts?.tagPostDtoList?[index].title,
                url: self?.keywordsPosts?.tagPostDtoList?[index].url
            )
            
            // MARK: - fix me, 스크랩 추가 Input 연결 필요
//            self?.viewModel?.cellDidTap(input: post)
            completionHaldler(true)
        })
        swipeAction.backgroundColor = .brandColor
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
}
