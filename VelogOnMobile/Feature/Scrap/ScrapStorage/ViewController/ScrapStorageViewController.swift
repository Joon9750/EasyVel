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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.rightBarButtonItems = nil
    }
}
