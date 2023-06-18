//
//  ViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import Foundation

import RxSwift
import RxRelay

final class SignInViewController: RxBaseViewController<SignInViewModel> {
    
    let signInView = SignInView()
    
    override func render() {
        view = signInView
    }
    
    override func bind(viewModel: SignInViewModel) {
        super.bind(viewModel: viewModel)
        
        signInView.appleSignInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.appleSignInButtonTapped.accept(true)
                self?.pushToTabBarController()
            })
            .disposed(by: disposeBag)
    }
    
    private func pushToTabBarController() {
        let tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
