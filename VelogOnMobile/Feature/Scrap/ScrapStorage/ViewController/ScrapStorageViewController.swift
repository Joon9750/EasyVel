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
    private var scrapCollectionViewDidScroll = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotification()
    }
    
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
                    storageViewController.setStorageHeadView(
                        headTitle: folderName
                    )
                }
                self?.navigationController?.pushViewController(storageViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        scrapView.addFolderButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.addFolderAlert()
            })
            .disposed(by: disposeBag)
        
        scrapView.scrapCollectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                let scrollY = contentOffset.y
                if scrollY > 5 && self?.scrapCollectionViewDidScroll == false {
                    self?.scrapView.scrapCollectionViewStartScroll()
                    self?.scrapCollectionViewDidScroll.toggle()
                } else if scrollY < 2 && self?.scrapCollectionViewDidScroll == true {
                    self?.scrapView.scrapCollectionViewEndScroll()
                    self?.scrapCollectionViewDidScroll.toggle()
                }
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
        
        viewModel.alreadyHaveFolderNameRelay
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] alreadyHaveFolderName in
                if alreadyHaveFolderName {
                    self?.showAlreadyHaveFolderToast(
                        toastText: TextLiterals.alreadyHaveFolderToastText,
                        toastBackgroundColer: .gray300
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addFolderAlert() {
        let alertController = UIAlertController(
            title: TextLiterals.addFolderAlertTitle,
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField()
        let okAction = UIAlertAction(
            title: TextLiterals.addFolderAlertOkActionTitle,
            style: .default
        ) { [weak self] action in
            if let folderTextField = alertController.textFields?.first,
               let addFolderName = folderTextField.text {
                self?.viewModel?.addFolderInput.accept(addFolderName)
            }
        }
        let cancelAction = UIAlertAction(
            title: TextLiterals.addFolderAlertCancelActionTitle,
            style: .cancel
        )
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func showAlreadyHaveFolderToast(
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
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollToTop),
            name: Notification.Name("scrollToTop"),
            object: nil
        )
    }
    
    @objc
    private func scrollToTop() {
        let topIndexPath = IndexPath(item: 0, section: 0)
        scrapView.scrapCollectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
    }
}
