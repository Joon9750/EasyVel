//
//  SignInRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

import Moya

enum TagAPI {
    case addTag(tag: String)
    case deleteTag(tag: String)
    case getTag
}

extension TagAPI: BaseTargetType {
    var path: String {
        switch self {
        case .addTag:
            return URLConstants.tag + "/addtag"
        case .deleteTag:
            return URLConstants.tag + "/deletetag"
        case .getTag:
            return URLConstants.tag + "/gettag"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addTag:
            return .post
        case .deleteTag:
            return .delete
        case .getTag:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addTag(let tag):
            return .requestParameters(
                parameters: ["tag": tag],
                encoding: URLEncoding.queryString
            )
        case .deleteTag(let tag):
            return .requestParameters(
                parameters: ["tag": tag],
                encoding: URLEncoding.queryString
            )
        case .getTag:
            return .requestPlain
        }
    }
}
