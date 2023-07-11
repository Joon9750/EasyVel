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
        target()
    }
    
    private func target() {
        signInView.appleSignInButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
    }
    
    override func bind(viewModel: SignInViewModel) {
        super.bind(viewModel: viewModel)
        
        bindOutput(viewModel)
    }
    
    private func bindOutput(_ viewModel: SignInViewModel) {
        viewModel.appleLoginOutput
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { isSuccess in
                if isSuccess {
                    let tabVC = TabBarController()
                    let tabNVC = UINavigationController(rootViewController: tabVC)
                    UIApplication.shared.changeRootViewController(tabNVC)
                }
                else {
                    self.showToast(toastText: "로그인에 실패하였습니다.", backgroundColor: .gray300)
                }
            })
            .disposed(by: disposeBag)
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
            let idToken = credential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)

            guard let tokeStr else { return }
            viewModel?.didCompleteWithAuthorization.accept(tokeStr)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showToast(toastText: "애플 로그인 오류가 발생했습니다.", backgroundColor: .gray200)
    }
}
