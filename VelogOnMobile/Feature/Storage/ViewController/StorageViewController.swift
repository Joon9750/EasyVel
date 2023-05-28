//
//  StorageViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import RxSwift
import RxCocoa

final class StorageViewController: RxBaseViewController<StorageViewModel> {
    
    private let storageView = StorageView()
    private var isScrolled: Bool = false
    private var storagePosts: [StoragePost]?

    override func render() {
        self.view = storageView
    }
    
    override func bind(viewModel: StorageViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        setButtonAction()
        storageView.listTableView.dataSource = self
        storageView.listTableView.delegate = self
    }
    
    private func bindOutput(_ viewModel: StorageViewModel) {
        viewModel.storagePostsOutput
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] post in
                self?.storagePosts = post
                self?.storageView.listTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.isPostsEmptyOutput
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] isPostsEmpty in
                if isPostsEmpty {
                    self?.storageView.storageViewExceptionView.isHidden = false
                } else {
                    self?.storageView.storageViewExceptionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func emptySelectedList() {
        if storageView.listTableView.isEditing {
            storageView.storageHeadView.deleteButton.setTitle(TextLiterals.deleteButtonTitle, for: .normal)
            storageView.storageHeadView.deleteButton.setTitleColor(.red, for: .normal)
            storageView.listTableView.setEditing(false, animated: true)
        } else {
            storageView.storageHeadView.deleteButton.setTitle(TextLiterals.doneButtonTitle, for: .normal)
            storageView.storageHeadView.deleteButton.setTitleColor(.blue, for: .normal)
            storageView.listTableView.setEditing(true, animated: true)
        }
    }
    
    private func setButtonAction() {
        storageView.moveToTopButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
    }
}

extension StorageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 2 {
            if isScrolled == false {
                storageView.scrollDidStart()
                isScrolled = true
            }
        } else if scrollView.contentOffset.y < 0 {
            storageView.scrollDidEnd()
            isScrolled = false
        }
        if scrollView.contentOffset.y > 200 {
            storageView.moveToTopButton.isHidden = false
        } else {
            storageView.moveToTopButton.isHidden = true
        }
    }
    
    @objc
    func scrollToTop() {
        storageView.listTableView.setContentOffset(CGPoint(x: 0, y: -1), animated: true)
    }
}

extension StorageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return storagePosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StorageTableViewCell.identifier, for: indexPath) as? StorageTableViewCell ?? StorageTableViewCell()
        cell.selectionStyle = .none
        let index = indexPath.section
        if let data = storagePosts?[index] {
            cell.binding(model: data)
            return cell
        }
        return cell
    }
}

extension StorageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textNum = storagePosts?[indexPath.section].summary?.count ?? 0
        if storagePosts?[indexPath.section].img ?? String() == TextLiterals.noneText {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! StorageTableViewCell
        let url = selectedCell.url
        let webViewModel = WebViewModel(url: url)
        let webViewController = WebViewController(viewModel: webViewModel)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedCell = tableView.cellForRow(at: indexPath) as! StorageTableViewCell
        let swipeAction = UIContextualAction(style: .destructive, title: TextLiterals.tableViewDeleteSwipeTitle, handler: { action, view, completionHaldler in
            
            // MARK: - fix me, 스크랩 삭제 Input 연결 필요
//            self.viewModel?.deletePostButtonDidTap(url: selectedCell.url)
            completionHaldler(true)
        })
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedCell = tableView.cellForRow(at: indexPath) as! StorageTableViewCell
            
            // MARK: - fix me, 스크랩 삭제 Input 연결 필요
//            viewModel?.deletePostButtonDidTap(url: selectedCell.url)
        }
    }
}
