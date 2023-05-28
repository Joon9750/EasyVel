//
//  ScrapFolderBottomSheetViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import RxSwift
import RxRelay

final class ScrapFolderBottomSheetViewController: RxBaseViewController<ScrapFolderBottomSheetViewModel> {
    
    let scrapFolderBottomSheetView = ScrapFolderBottomSheetView()
    private lazy var dataSource = ScrapFolderBottomSheetDataSource(tableView: scrapFolderBottomSheetView.folderTableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func render() {
        self.view = scrapFolderBottomSheetView
    }
    
    override func bind(viewModel: ScrapFolderBottomSheetViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
    }
    
    private func bindOutput(_ viewModel: ScrapFolderBottomSheetViewModel) {
        viewModel.folderNameListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] folderList in
                self?.dataSource.update(list: folderList)
            })
            .disposed(by: disposeBag)
    }
}

