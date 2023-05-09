//
//  KeywordsPostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class KeywordsPostsViewController: BaseViewController {
    
    private let keywordsPostsView = KeywordsPostsView()
    private var viewModel: KeywordsPostsViewModelInputOutput?
    private var keywordsPosts: GetTagPostResponse? {
        didSet {
            keywordsPostsView.keywordsTableView.reloadData()
        }
    }
    
    init(viewModel: KeywordsPostsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.view = keywordsPostsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func bind() {
        setButtonAction()
        keywordsPostsView.keywordsTableView.dataSource = self
        keywordsPostsView.keywordsTableView.delegate = self
        viewModel?.tagPostsListOutput = { [weak self] postsResult in
            self?.keywordsPosts = postsResult
        }
        viewModel?.toastPresent = { [weak self] result in
            if result {
                self?.showToast(message: "추가되었습니다.", font: UIFont(name: "Avenir-Black", size: 14) ?? UIFont())
            } else {
                self?.showToast(message: TextLiterals.alreadyAddToastText, font: UIFont(name: "Avenir-Black", size: 14) ?? UIFont())
            }
        }
        viewModel?.isPostsEmpty = { [weak self] isEmpty in
            if isEmpty {
                self?.keywordsPostsView.keywordsPostsViewExceptionView.isHidden = false
            } else {
                self?.keywordsPostsView.keywordsPostsViewExceptionView.isHidden = true
            }
        }
    }
    
    private func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-50, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.brandColor
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func setButtonAction() {
        keywordsPostsView.moveToTopButton.addTarget(self, action: #selector(moveToTop), for: .touchUpInside)
    }
    
    @objc
    func moveToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        keywordsPostsView.keywordsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension KeywordsPostsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 {
            keywordsPostsView.moveToTopButton.isHidden = false
        } else {
            keywordsPostsView.moveToTopButton.isHidden = true
        }
        if scrollView.contentOffset.y < -100 {
            viewModel?.tableViewReload()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: KeywordsTableViewCell.identifier, for: indexPath) as? KeywordsTableViewCell ?? KeywordsTableViewCell()
        cell.selectionStyle = .none
        let index = indexPath.section
        if let data = keywordsPosts?.tagPostDtoList?[index] {
            cell.binding(model: data)
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
            return SizeLiterals.postCellLarge
        }
    }
}

extension KeywordsPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! KeywordsTableViewCell
        let url = selectedCell.url
        let webViewController = WebViewController(url: url)
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
            self?.viewModel?.cellDidTap(input: post)
            completionHaldler(true)
        })
        swipeAction.backgroundColor = .brandColor
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
}
