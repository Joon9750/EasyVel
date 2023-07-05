//
//  ScrapFolderBottomSheetViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class ScrapFolderBottomSheetViewController: RxBaseViewController<ScrapFolderBottomSheetViewModel> {
    
    private var keyboardHeight: CGFloat = 0.0
    
    let scrapFolderBottomSheetView = ScrapFolderBottomSheetView()
    private lazy var dataSource = ScrapFolderBottomSheetDataSource(
        tableView: scrapFolderBottomSheetView.folderTableView
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyBoardNotification()
    }
    
    override func configUI() {
        self.view.backgroundColor = .white
    }
    
    override func render() {
        view.addSubviews(scrapFolderBottomSheetView)
        
        scrapFolderBottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setupSheet()
    }
    
    override func bind(viewModel: ScrapFolderBottomSheetViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
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

        scrapFolderBottomSheetView.folderTableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                let cell = self?.scrapFolderBottomSheetView.folderTableView.cellForRow(at: indexPath) as? ScrapFolderBottomSheetTableViewCell
                if let selectedFolderTitle = cell?.folderTitleLabel.text {
                    self?.viewModel?.selectedFolderTableViewCell.accept(selectedFolderTitle)
                }
                self?.dismiss(animated: true)
            }
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
                self?.showToast(
                    toastText: TextLiterals.alreadyHaveFolderToastText,
                    backgroundColor: .gray300
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func setKeyBoardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
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
