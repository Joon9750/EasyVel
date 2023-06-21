//
//  MyPageViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import RxSwift


final class SettingViewController: RxBaseViewController<SettingViewModel> {
    
    private let settingView = SettingView()
    
    override func render() {
        self.view = settingView
    }
    
    override func configUI() {
        view.backgroundColor = .white
    }
    
    override func bind(viewModel: SettingViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        settingView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if indexPath.row == 0 {
                    self?.presentAlert(
                        title: TextLiterals.signOutAlertTitle,
                        message: TextLiterals.signOutAlertMessage,
                        touchedIndexPath: indexPath.row
                    )
                } else if indexPath.row == 1 {
                    self?.presentAlert(
                        title: TextLiterals.withdrawalAlertTitle,
                        message: TextLiterals.withdrawalAlertMessage,
                        touchedIndexPath: indexPath.row
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: SettingViewModel) {
        viewModel.didWithdrawalSuccess
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] didSuccess in
                if didSuccess {
                    self?.pushToSignInView()
                } else {
                    // MARK: - 회원탈퇴 실패
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(
        title: String,
        message: String,
        touchedIndexPath: Int
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let actionDefault = UIAlertAction(
            title: TextLiterals.settingAlertOkActionText,
            style: .destructive,
            handler: { [weak self] _ in
                if touchedIndexPath == 0 {
                    self?.viewModel?.signOutCellDidTouched.accept(true)
                    self?.pushToSignInView()
                } else if touchedIndexPath == 1 {
                    self?.viewModel?.withdrawalCellDidTouched.accept(true)
                }
            })
        let actionCancel = UIAlertAction(
            title: TextLiterals.settingAlertCancelActionText,
            style: .cancel
        )
        alertController.addAction(actionDefault)
        alertController.addAction(actionCancel)
        self.present(alertController, animated: true)
    }
    
    private func pushToSignInView() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
}
