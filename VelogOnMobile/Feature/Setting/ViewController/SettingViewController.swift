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
                    self?.presentSignOutAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: SettingViewModel) {
        
    }
    
    private func presentSignOutAlert() {
        let alertController = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        let actionDefault = UIAlertAction(title: "네", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.signOutCellDidTouched.accept(true)
            self?.pushToSignInView()
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
