//
//  SignInUseCase.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/09.
//

import Foundation

import RxSwift

protocol SignInUseCase {
    func appleLogin(_ identityToken: String) -> Observable<Bool>
}

final class DefaultSignInUseCase: SignInUseCase {
    
    //MARK: - Properties
    
    let repository: UserRepository
    
    //MARK: - Life Cycle

    init(repository: UserRepository) {
        self.repository = repository
    }
    
    //MARK: - Public Methods
    
    func appleLogin(_ identityToken: String) -> Observable<Bool> {
        repository.requestAppleLogin(identityToken)
            .flatMap { accessToken in
                self.repository.saveAccessToken(accessToken)
                return Observable.just(true)
            }
    }
}

extension DefaultSignInUseCase {
    
}


