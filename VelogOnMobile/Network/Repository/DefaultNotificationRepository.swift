//
//  NotificationAPI.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

final class DefaultNotificationRepository: BaseRepository, NotificationRepository {

    let provider = MoyaProvider<NotificationAPI>(plugins: [MoyaLoggerPlugin()])
    
    func broadCast(body: BroadcastRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.request(.broadCast(body: body)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .broadCast)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
