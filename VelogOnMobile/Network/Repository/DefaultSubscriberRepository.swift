//
//  SubscriberAPI.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

final class DefaultSubscriberRepository: BaseRepository, SubscriberRepository {
    
    let provider = MoyaProvider<SubscriberAPI>(plugins: [MoyaLoggerPlugin()])
    
    func addSubscriber(
        fcmToken: String,
        name: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.addSubscriber(fcmToken: fcmToken, name: name)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .addSubscriber)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getSubscriber(completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.request(.getSubscriber) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getSubscriber)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func searchSubscriber(name: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.request(.searchSubscriber(name: name)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .searchSubscriber)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteSubscriber(targetName: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.request(.deleteSubscriber(targetName: targetName)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .deleteSubscriber)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
