//
//  PostsRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum PostsAPI {
    case getSubscriberPosts
    case getTagPosts
}

extension PostsAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getSubscriberPosts:
            return URLConstants.subscriber + "/subscriberpost"
        case .getTagPosts:
            return URLConstants.tag + "/tagpost"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSubscriberPosts, .getTagPosts:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSubscriberPosts, .getTagPosts:
            return .requestPlain
        }
    }
}
