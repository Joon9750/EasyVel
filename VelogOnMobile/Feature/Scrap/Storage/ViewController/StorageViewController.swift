//
//  StorageViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class StorageViewController: RxBaseViewController<StorageViewModel> {
    
    private let storageView = StorageView()
    private var storagePosts: [StoragePost]?
    private var storageTableViewDidScroll = false

    override func render() {
        self.view = storageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
  
    override func bind(viewModel: StorageViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        setDelegate()
        
        storageView.storageHeadView.deleteFolderButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentDeleteFolderActionSheet()
            })
            .disposed(by: disposeBag)
        
        storageView.storageHeadView.changeFolderNameButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.changeFolderNameAlert()
            })
            .disposed(by: disposeBag)
        
        storageView.listTableView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                let scrollY = contentOffset.y
                let isAllScrapFolder = self?.viewModel?.folderName == TextLiterals.allPostsScrapFolderText ? true : false
                if scrollY > 5 && self?.storageTableViewDidScroll == false {
                    self?.storageView.storageTableViewStartScroll()
                    self?.storageTableViewDidScroll.toggle()
                } else if scrollY < 2 && self?.storageTableViewDidScroll == true {
                    self?.storageView.storageTableViewEndScroll(
                        isAllpostFolder: isAllScrapFolder
                    )
                    self?.storageTableViewDidScroll.toggle()
                }
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
                if folderName == TextLiterals.allPostsScrapFolderText {
                    self?.storageView.storageHeadView.deleteFolderButton.isHidden = true
                    self?.storageView.storageHeadView.changeFolderNameButton.isHidden = true
                } else {
                    self?.storageView.storageHeadView.deleteFolderButton.isHidden = false
                    self?.storageView.storageHeadView.changeFolderNameButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.newFolderNameIsUniqueOutput
            .asDriver(onErrorJustReturn: (String(), Bool()))
            .drive(onNext: { [weak self] newFolderName, isUniqueName in
                if isUniqueName {
                    self?.storageView.storageHeadView.titleLabel.text = newFolderName
                    self?.showChangeFolderNameToast(
                        toastText: TextLiterals.folderNameChangeSuccessToastText,
                        toastBackgroundColer: .brandColor
                    )
                } else {
                    self?.showChangeFolderNameToast(
                        toastText: TextLiterals.alreadyHaveFolderToastText,
                        toastBackgroundColer: .gray300
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setStorageHeadView(
        headTitle: String
    ) {
        storageView.storageHeadView.titleLabel.text = headTitle
    }
    
    private func setDelegate() {
        storageView.listTableView.dataSource = self
        storageView.listTableView.delegate = self
    }
    
    private func showChangeFolderNameToast(
        toastText: String,
        toastBackgroundColer: UIColor
    ) {
        let toastLabel = UILabel()
        toastLabel.text = toastText
        toastLabel.textColor = .white
        toastLabel.font = .body_2_M
        toastLabel.backgroundColor = toastBackgroundColer
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 24
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 1.0
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(51)
            $0.height.equalTo(48)
        }
        UIView.animate(withDuration: 0, animations: {
            toastLabel.alpha = 1.0
        }, completion: { isCompleted in
            UIView.animate(withDuration: 0.5, delay: 3.0, animations: {
                toastLabel.alpha = 0
            }, completion: { isCompleted in
                toastLabel.removeFromSuperview()
            })
        })
    }
    
    private func presentDeleteFolderActionSheet() {
        let actionSheetController = UIAlertController(
            title: TextLiterals.deleteFolderActionSheetTitle,
            message: TextLiterals.deleteFolderActionSheetMessage,
            preferredStyle: .actionSheet
        )
        let actionDefault = UIAlertAction(
            title: TextLiterals.deleteFolderActionSheetOkActionText,
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel?.deleteFolderButtonDidTap.accept(true)
                self?.navigationController?.popViewController(animated: true)
            })
        let actionCancel = UIAlertAction(
            title: TextLiterals.deleteFolderActionSheetCancelActionText,
            style: .cancel
        )
        actionSheetController.addAction(actionDefault)
        actionSheetController.addAction(actionCancel)
        self.present(actionSheetController, animated: true)
    }
    
    private func changeFolderNameAlert() {
        let alertController = UIAlertController(
            title: TextLiterals.folderNameChangeToastTitle,
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField()
        let okAction = UIAlertAction(
            title: TextLiterals.folderNameChangeToastOkActionText,
            style: .default
        ) { [weak self] action in
            if let folderTextField = alertController.textFields?.first,
               let changeFolderName = folderTextField.text,
               let stoagePosts = self?.storagePosts {
                self?.viewModel?.changeFolderButtonDidTap.accept(
                    (stoagePosts, changeFolderName)
                )
            }
        }
        let cancelAction = UIAlertAction(
            title: TextLiterals.folderNameChangeToastCancelActionText,
            style: .cancel
        )
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
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
        let webViewModel = WebViewModel(url: url, isPostWebView: true)
        let webViewController = WebViewController(viewModel: webViewModel)
        webViewController.isPostWebView = true
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
