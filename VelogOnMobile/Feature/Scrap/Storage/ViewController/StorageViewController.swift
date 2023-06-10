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
    private var storagePosts: [StoragePost]?

    override func render() {
        self.view = storageView
    }
    
    override func bind(viewModel: StorageViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        storageView.listTableView.dataSource = self
        storageView.listTableView.delegate = self
        
        storageView.storageHeadView.deleteFolderButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentDeleteFolderActionSheet()
            })
            .disposed(by: disposeBag)
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
        
        viewModel.folderNameOutput
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: { [weak self] folderName in
                if folderName == "모든 게시글" {
                    self?.storageView.storageHeadView.deleteFolderButton.isHidden = true
                } else {
                    self?.storageView.storageHeadView.deleteFolderButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func presentDeleteFolderActionSheet() {
        let actionSheetController = UIAlertController(title: "폴더 삭제", message: "선택하신 폴더를 정말 삭제하시겠습니까?\n스크랩한 콘텐츠가 모두 삭제됩니다.", preferredStyle: .actionSheet)
        let actionDefault = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.deleteFolderButtonDidTap.accept(true)
            self?.navigationController?.popViewController(animated: true)
        })
        let actionCancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheetController.addAction(actionDefault)
        actionSheetController.addAction(actionCancel)
        self.present(actionSheetController, animated: true)
    }

    func setStorageViewHeadTitle(
        headTitle: String
    ) {
        storageView.storageHeadView.titleLabel.text = headTitle
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StorageTableViewCell.identifier, for: indexPath) as? StorageTableViewCell else {
            return StorageTableViewCell()
        }
        cell.selectionStyle = .none
        cell.deleteButtonTappedClosure = { [weak self] url in
            self?.viewModel?.deletePostButtonDidTap.accept(url)
        }
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
}
