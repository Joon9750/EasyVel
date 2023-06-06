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
    private lazy var dataSource = ScrapStorageCollectionViewDataSource(collectionView: scrapView.scarpCollectionView)

    override func render() {
        view = scrapView
    }
    
    override func bind(viewModel: ScrapStorageViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
    }
    
    private func bindOutput(_ viewModel: ScrapStorageViewModel) {
        viewModel.storageListOutput
            .asDriver(onErrorJustReturn: ([StorageDTO](), [String]()))
            .drive(onNext: { [weak self] folderData, folderImageList in
                self?.dataSource.update(
                    folderData: folderData,
                    folderImageList: folderImageList
                )
            })
            .disposed(by: disposeBag)
    }
}
