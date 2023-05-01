//
//  SignRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum SignRouter {
    case signIn(body: SignInRequest)
    case signOut(body: SignOutRequest)
    case signUp(body: SignUpRequest)
}

extension SignRouter: BaseTargetType {
    var path: String {
        switch self {
        case .signIn:
            return URLConstants.sign + "/sign-in"
        case .signOut:
            return URLConstants.sign + "/sign-out"
        case .signUp:
            return URLConstants.sign + "/sign-up"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signOut, .signUp:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let body):
            return .requestJSONEncodable(body)
        case .signOut(let body):
            return .requestJSONEncodable(body)
        case .signUp(let body):
            return .requestJSONEncodable(body)
        }
    }
}

