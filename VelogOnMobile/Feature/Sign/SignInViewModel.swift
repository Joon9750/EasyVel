//
//  SignInViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/18.
//

import Foundation

import RxSwift
import RxRelay

final class SignInViewModel: BaseViewModel {
    
    private let useCase: SignInUseCase
    
    //MARK: - Input
    
    let didCompleteWithAuthorization = PublishRelay<String>()
    
    //MARK: - Output
    
    let appleLoginOutput = PublishRelay<Bool>()
    
    //MARK: - Life Cycle

    init(useCase: SignInUseCase) {
        self.useCase = useCase
        super.init()
        
        makeOutput()
    }
    
    private func makeOutput() {
        didCompleteWithAuthorization
            .subscribe(onNext: { [weak self] identityToken in
                self?.appleLogin(identityToken)
            })
            .disposed(by: disposeBag)
    }
}

extension SignInViewModel {
    
    func appleLogin(_ identityToken:String) {
        useCase.appleLogin(identityToken)
            .subscribe(onNext: { [weak self] isSuccess in
                self?.appleLoginOutput.accept(isSuccess)
            }, onError: { [weak self] error in
                guard let error = error as? AuthError else { return }
                self?.appleLoginOutput.accept(false)
                print("⚠️⚠️\(error.description)⚠️⚠️")
            })
            .disposed(by: disposeBag)
    }
}
