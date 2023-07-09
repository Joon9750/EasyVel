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
                    let webViewModel = WebViewModel(url: TextLiterals.userInformationProcessingpPolicyWebUrl)
                    let webViewController = WebViewController(viewModel: webViewModel)
                    self.navigationController?.pushViewController(webViewController, animated: true)
                    break
                case 1:
                    let webViewModel = WebViewModel(url: TextLiterals.provisionWebUrl)
                    let webViewController = WebViewController(viewModel: webViewModel)
                    self.navigationController?.pushViewController(webViewController, animated: true)
                    break
                case 2:
                    alertType = .signOut
                    let alertVC = VelogAlertViewController(
                        alertType: alertType,
                        delegate: self
                    )
                    present(alertVC, animated: false)
                case 3:
                    alertType = .withdrawal
                    let alertVC = VelogAlertViewController(
                        alertType: alertType,
                        delegate: self
                    )
                    present(alertVC, animated: false)
                default:
                    return
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
                    self?.showToast(
                        toastText: "회원탈퇴에 실패하였습니다.",
                        backgroundColor: .gray200
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func pushToSignInView() {
        let signInVM = SignInViewModel(
            useCase: DefaultSignInUseCase(
                repository: DefaultUserRepository(
                    service: DefaultSignRepository()
                )
            )
        )
        let signInViewController = SignInViewController(viewModel: signInVM)
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
