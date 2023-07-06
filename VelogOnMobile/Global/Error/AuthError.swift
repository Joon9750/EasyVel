//
//  AuthError.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/07.
//

import Foundation

enum AuthError: Error {
    case unknown
    case noAccessToken
    case refreshError
    case serverFail
    case decodedError
    
    var description: String {
        switch self {
            
        case .unknown:
            return "메모리 오류인 것 같습니다"
        case .noAccessToken:
            return "Realm에 토큰이 존재하지 않습니다."
        case .refreshError:
            return "토큰 리프레시 서버통신이 실패했습니다."
        case .serverFail:
            return "알 수 없는 서버 오류가 발생했습니다."
        case .decodedError:
            return "디코딩 오류가 발생했습니다."
        }
    }
}
