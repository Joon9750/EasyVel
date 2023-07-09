//
//  SignRouter.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

enum SignAPI {
    case appleSignIn(identityToken: String)
    case signIn(body: SignInRequest)
    case signOut
    case signUp(body: SignUpRequest)
    case refreshToken(token: String)
}

extension SignAPI: BaseTargetType {
    var path: String {
        switch self {
        case .appleSignIn:
            return URLConstants.sign + "/apple-login"
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
        case .appleSignIn, .signIn, .signOut, .signUp, .refreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .appleSignIn(let identityToken):
            return .requestParameters(parameters: ["authorization_code": "",
                                                   "identity_token": identityToken],
                                      encoding: JSONEncoding.default)
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
    var headers: [String : String]? {
        switch self {
        case .appleSignIn:
            return ["Content-Type": "application/json"]
        default:
            return [ "Content-Type": "application/json",
                     "X-AUTH-TOKEN": RealmService().getAccessToken()]
        }
    }
}

