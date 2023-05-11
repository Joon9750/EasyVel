//
//  SignAPI.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

final class DefaultSignRepository: BaseRepository, SignRepository {
    
    let provider = MoyaProvider<SignAPI>(plugins: [MoyaLoggerPlugin()])
    
    func signIn(
        body: SignInRequest,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.signIn(body: body)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .signIn)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func signOut(
        body: SignOutRequest,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.signOut(body: body)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .signOut)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func signUp(
        body: SignUpRequest,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.signUp(body: body)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .signUp)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
