//
//  SpashUseCase.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/07.
//

import Foundation

import RxSwift

//MARK: - [Clean Architecture] Domain Layer

protocol SplashUseCase {
    func autoLogin() -> Observable<Bool>
}

final class DefaultSplashUseCase: SplashUseCase {
    
    //MARK: - Properties
    
    private let repository: UserRepository
    
    //MARK: - Life Cycle

    init(repository: UserRepository) {
        self.repository = repository
    }
    
    //MARK: - Public Methods
    
    func autoLogin() -> Observable<Bool> {
        let token = fetchRealmAccessToken()
        guard token.isValidText else { return Observable.error(AuthError.noAccessToken) }
        return refreshAccessToken(token)
    }
}

//MARK: - Private Methods

extension DefaultSplashUseCase {
    
    private func fetchRealmAccessToken() -> String {
       repository.fetchAccessToken()
    }
    
    private func refreshAccessToken(_ accessToken: String) -> Observable<Bool> {
        repository.refreshAccessToken(accessToken)
            .flatMap { refreshToken in
                self.saveRefreshToken(refreshToken)
                return Observable.just(true)
            }
    }
    
    private func saveRefreshToken(_ refreshToken: String) {
        repository.saveAccessToken(refreshToken)
    }
}
    
    
