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
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.signOut) { result in
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
    
    func refreshToken(
        token: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.refreshToken(token: token)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .refreshToken)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func appleSignIn(
        identityToken: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.appleSignIn(identityToken: identityToken)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let decoder = JSONDecoder()
                
                switch statusCode {
                case 200..<300:
                    guard let decodedData = try? decoder.decode(SignInResponse.self, from: data) else {
                        completion(.decodedErr)
                        return
                    }
                    completion(.success(decodedData))
                    
                case 400..<500:
                    self.provider.request(.appleSignIn(identityToken: identityToken)) { result in
                        switch result {
                        case .success(let response):
                            let statusCode = response.statusCode
                            let data = response.data
                            switch statusCode {
                            case 200..<300:
                                guard let decodedData = try? decoder.decode(SignInResponse.self, from: data) else {
                                    completion(.decodedErr)
                                    return
                                }
                                completion(.success(decodedData))
                                
                            case 400..<500:
                                completion(.pathErr)
                            case 500:
                                completion(.serverErr)
                            default:
                                completion(.networkFail)
                                //MARK: - retry
                            }
                            
                        case .failure:
                            completion(.networkFail)
                        }
                       
                        return
                    }
                        
                case 500:
                    completion(.serverErr)
                default:
                    completion(.networkFail)
                }
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
