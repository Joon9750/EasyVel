//
//  UserRepository.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/07.
//

import Foundation

import RxSwift

//MARK: - Data Layer

protocol UserRepository {
    func fetchAccessToken() -> String
    func saveAccessToken(_ token: String)
    func refreshAccessToken(_ token: String) -> Observable<String>
}

final class DefaultUserRepository: UserRepository {
    
    //MARK: - Properties
    
    private let service: SignRepository
    
    //MARK: - Life Cycle

    init(service: SignRepository) {
        self.service = service
    }
    
    //MARK: - Realm
    
    func fetchAccessToken() -> String {
        RealmService().getAccessToken()
    }
    
    func saveAccessToken(_ token: String) {
        RealmService().setAccessToken(accessToken: token)
    }
    
    //MARK: - Network
    
    func refreshAccessToken(_ token: String) -> Observable<String> {
        return Observable<String>.create { observer in
            self.service.refreshToken(token: token) { result in
                switch result {
                case .success(let data):
                    guard let refreshToken = data as? String else { return
                        observer.onError(AuthError.decodedError)
                    }
                    observer.onNext(refreshToken)
                    observer.onCompleted()
                case .decodedErr:
                    observer.onError(AuthError.decodedError)
                default:
                    observer.onError(AuthError.refreshError)
                }
            }
            return Disposables.create()
        }
    }
    
    
}
