//
//  NotificationRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum NotificationRouter {
    case broadCast(body: BroadcastRequest)
}

extension NotificationRouter: BaseTargetType {
    var path: String {
        switch self {
        case .broadCast:
            return URLConstants.notifi + "/broadcast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .broadCast:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .broadCast(let body):
            return .requestJSONEncodable(body)
        }
    }
}
