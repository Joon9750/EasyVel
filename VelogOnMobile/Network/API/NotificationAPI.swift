//
//  NotificationRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum NotificationAPI {
    case broadCast(body: BroadcastRequest)
    case joingroup(body: JoinGroupRequest)
}

extension NotificationAPI: BaseTargetType {
    var path: String {
        switch self {
        case .broadCast:
            return URLConstants.notifi + "/broadcast"
        case .joingroup:
            return URLConstants.notifi + "/joingroup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .broadCast, .joingroup:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .broadCast(let body):
            return .requestJSONEncodable(body)
        case .joingroup(let body):
            return .requestJSONEncodable(body)
        }
    }
}
