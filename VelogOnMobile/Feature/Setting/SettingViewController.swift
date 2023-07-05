//
//  SettingViewController.swift
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
                guard let self else { return }
                let alertType: AlertType
                switch indexPath.row {
                case 0:
                    alertType = .signOut
                case 1:
                    alertType = .withdrawal
                default:
                    return
                }
                let alertVC = VelogAlertViewController(alertType: alertType,
                                                       delegate: self)
                present(alertVC, animated: false)
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
    
    private func pushToSignInView() {
        
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        UIApplication.shared.changeRootViewController(signInViewController)
    }
}

extension SettingViewController: VelogAlertViewControllerDelegate {
    func yesButtonDidTap(_ alertType: AlertType) {
        switch alertType {
        case .signOut:
            viewModel?.signOutCellDidTouched.accept(true)
            pushToSignInView()
        case .withdrawal:
            viewModel?.withdrawalCellDidTouched.accept(true)
        default:
            return
        }
    }
    
    
}
