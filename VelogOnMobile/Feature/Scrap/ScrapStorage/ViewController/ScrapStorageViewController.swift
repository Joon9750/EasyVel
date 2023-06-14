//
//  ScrapStorageViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class ScrapStorageViewController: RxBaseViewController<ScrapStorageViewModel> {
    
    let scrapView = ScrapStorageView()
    private lazy var dataSource = ScrapStorageCollectionViewDataSource(collectionView: scrapView.scrapCollectionView)

    override func render() {
        view = scrapView
    }
    
    override func bind(viewModel: ScrapStorageViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        scrapView.scrapCollectionView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                let cell = self?.scrapView.scrapCollectionView.cellForItem(at: indexPath) as? ScrapStorageCollectionViewCell
                let storageViewModel = StorageViewModel()
                let storageViewController = StorageViewController(viewModel: storageViewModel)
                if let folderName = cell?.folderNameLabel.text {
                    storageViewModel.folderName = folderName
                    storageViewController.setStorageViewHeadTitle(headTitle: folderName)
                }
                self?.navigationController?.pushViewController(storageViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        scrapView.addFolderButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.addFolderAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: ScrapStorageViewModel) {
        viewModel.storageListOutput
            .asDriver(onErrorJustReturn: ([StorageDTO](), [String](), [Int]()))
            .drive(onNext: { [weak self] folderData, folderImageList, folderPostsCount in
                self?.dataSource.update(
                    folderData: folderData,
                    folderImageList: folderImageList,
                    folderPostsCount: folderPostsCount
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func addFolderAlert() {
        let alertController = UIAlertController(
            title: "폴더 추가",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField()
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            if let folderTextField = alertController.textFields?.first,
               let addFolderName = folderTextField.text {
                self?.viewModel?.addFolderInput.accept(addFolderName)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
