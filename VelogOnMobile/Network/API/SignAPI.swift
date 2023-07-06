//
//  SignRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum SignAPI {
    case signIn(body: SignInRequest)
    case signOut
    case signUp(body: SignUpRequest)
    case refreshToken(token: String)
}

extension SignAPI: BaseTargetType {
    var path: String {
        switch self {
        case .signIn:
            return URLConstants.sign + "/sign-in"
        case .signOut:
            return URLConstants.sign + "/sign-out"
        case .signUp:
            return URLConstants.sign + "/sign-up"
        case .refreshToken:
            return URLConstants.sign + "/refresh-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signOut, .signUp, .refreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let body):
            return .requestJSONEncodable(body)
        case .signOut:
            return .requestPlain
        case .signUp(let body):
            return .requestJSONEncodable(body)
        case .refreshToken(let token):
            return .requestJSONEncodable(token)
        }
    }
}

