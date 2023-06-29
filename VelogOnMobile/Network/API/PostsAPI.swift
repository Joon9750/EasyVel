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
    case getOneTagPosts(tag: String)
    case getPopularPosts
    case trendsPosts
}

extension PostsAPI: BaseTargetType {
    var path: String {
        switch self {
        case .getSubscriberPosts:
            return URLConstants.subscriber + "/subscriberpost"
        case .getTagPosts:
            return URLConstants.tag + "/tagpost"
        case .getOneTagPosts:
            return URLConstants.tag + "/gettagpost"
        case .getPopularPosts:
            return URLConstants.tag + "/popularpost"
        case .trendsPosts:
            return URLConstants.subscriber + "/trendposts"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSubscriberPosts, .getTagPosts, .getOneTagPosts, .getPopularPosts, .trendsPosts:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSubscriberPosts, .getTagPosts, .getPopularPosts, .trendsPosts:
            return .requestPlain
        case .getOneTagPosts(let tag):
            return .requestParameters(parameters: ["tag": tag], encoding: URLEncoding.default)
        }
    }
}
