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

        scrapFolderBottomSheetView.addFolderFinishedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let addFolderTitle: String = self?.scrapFolderBottomSheetView.newFolderAddTextField.text ?? ""
                self?.viewModel?.addNewFolderTitle.accept(addFolderTitle)
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
                let scrapFolderList = folderList.map {
                    ScrapFolder(title: $0,articleId: UUID())
                }
                self?.dataSource.update(list: scrapFolderList)
            })
            .disposed(by: disposeBag)
        
        viewModel.alreadyHaveFolderNameRelay
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] isAlreadyHave in
                // MARK: - fix me 이미 존재하는 폴더명일 경우 들어옴
                print("이미 존재라는 폴더명입니다.")
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
