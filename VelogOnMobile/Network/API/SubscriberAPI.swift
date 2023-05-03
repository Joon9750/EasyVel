//
//  SubscriberRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum SubscriberAPI {
    case addSubscriber(fcmToken: String, name: String)
    case getSubscriber
    case searchSubscriber(name: String)
    case deleteSubscriber(targetName: String)
}

extension SubscriberAPI: BaseTargetType {
    var path: String {
        switch self {
        case .addSubscriber:
            return URLConstants.subscriber + "/addsubscriber"
        case .getSubscriber:
            return URLConstants.subscriber + "/getsubscriber"
        case .searchSubscriber(let name):
            return URLConstants.subscriber + "/inputname/" + name
        case .deleteSubscriber(let targetName):
            return URLConstants.subscriber + "/unsubscribe/" + targetName
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addSubscriber:
            return .post
        case .getSubscriber, .searchSubscriber:
            return .get
        case .deleteSubscriber:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addSubscriber(let fcmToken, let name):
            return .requestParameters(
                parameters: ["fcmToken": fcmToken,
                             "name": name],
                encoding: URLEncoding.queryString
            )
        case .getSubscriber:
            return .requestPlain
        case .searchSubscriber(let name):
            return .requestParameters(
                parameters: ["name": name],
                encoding: URLEncoding.queryString
            )
        case .deleteSubscriber(let targetName):
            return .requestParameters(
                parameters: ["targetName": targetName],
                encoding: URLEncoding.queryString
            )
        }
    }
}
