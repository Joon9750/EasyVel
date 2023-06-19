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
                        title: "로그아웃",
                        message: "정말 로그아웃 하시겠습니까?",
                        touchedIndexPath: indexPath.row
                    )
                } else if indexPath.row == 1 {
                    self?.presentAlert(
                        title: "회원탈퇴",
                        message: "정말 회원탈퇴 하시겠습니까?\n복구하실 수 없습니다.",
                        touchedIndexPath: indexPath.row
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: SettingViewModel) {
        
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
        let actionDefault = UIAlertAction(title: "네", style: .destructive, handler: { [weak self] _ in
            if touchedIndexPath == 0 {
                self?.viewModel?.signOutCellDidTouched.accept(true)
                self?.pushToSignInView()
            } else if touchedIndexPath == 1 {
                self?.viewModel?.withdrawalCellDidTouched.accept(true)
                self?.pushToSignInView()
            }
        })
        let actionCancel = UIAlertAction(title: "아니요", style: .cancel)
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
