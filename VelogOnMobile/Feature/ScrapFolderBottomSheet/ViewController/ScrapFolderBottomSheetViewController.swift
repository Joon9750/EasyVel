//
//  ScrapFolderBottomSheetViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class ScrapFolderBottomSheetViewController: RxBaseViewController<ScrapFolderBottomSheetViewModel> {
    
    let scrapFolderBottomSheetView = ScrapFolderBottomSheetView()
    private lazy var dataSource = ScrapFolderBottomSheetDataSource(tableView: scrapFolderBottomSheetView.folderTableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheetWithAnimation()
    }
    
    override func configUI() {
        self.view.backgroundColor = .clear
    }
    
    override func render() {
        view.addSubviews(scrapFolderBottomSheetView)
        
        scrapFolderBottomSheetView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(SizeLiterals.screenHeight / 2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.screenHeight / 2)
        }
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
    
    private func showBottomSheetWithAnimation() {
        scrapFolderBottomSheetView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideBottomSheetWithAnimation() {
        scrapFolderBottomSheetView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(SizeLiterals.screenHeight / 2)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.view.backgroundColor = .clear
            self.dismiss(animated: false)
        }
    }
}
