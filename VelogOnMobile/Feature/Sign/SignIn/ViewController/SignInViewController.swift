//
//  ViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import Foundation

import AuthenticationServices
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
        
        signInView.realAppleSignInButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
    }
    
    private func pushToTabBarController() {
        let tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @objc
    func handleAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let code = credential.authorizationCode else { return }
            let codeStr = String(data: code, encoding: .utf8)
            
            let idToken = credential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)

            let user = credential.user
            
            print("codeStr",codeStr)
            print("tokeStr",tokeStr)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}
