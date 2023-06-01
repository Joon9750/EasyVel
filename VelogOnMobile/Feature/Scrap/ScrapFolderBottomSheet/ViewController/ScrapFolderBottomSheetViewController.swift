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

    override func configUI() {
        self.view.backgroundColor = .white
    }
    
    override func render() {
        view.addSubviews(scrapFolderBottomSheetView)
        
        scrapFolderBottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind(viewModel: ScrapFolderBottomSheetViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        setupSheet()
        
        scrapFolderBottomSheetView.newFolderButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.scrapFolderBottomSheetView.isAddFolderButtonTapped.toggle()
            })
            .disposed(by: disposeBag)
        
        scrapFolderBottomSheetView.newFolderAddTextField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.scrapFolderBottomSheetView.isStartWriting = !(text?.isEmpty ?? true)
            })
            .disposed(by: disposeBag)

        scrapFolderBottomSheetView.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: ScrapFolderBottomSheetViewModel) {
        viewModel.folderNameListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] folderList in
                self?.dataSource.update(list: folderList)
            })
            .disposed(by: disposeBag)
    }

    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 8.0
        }
    }
}
