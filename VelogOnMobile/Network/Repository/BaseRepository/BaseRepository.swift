//
//  BaseRepository.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

class BaseRepository {
    func judgeStatus(by statusCode: Int, _ data: Data, responseData: ResponseData) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        print("statusCode: ", statusCode)
        switch statusCode {
        case 200..<300:
            return isValidData(data: data, responseData: responseData)
        case 400..<500:
            guard let decodedData = try? decoder.decode(ErrorResponse.self, from: data) else {
                return .pathErr
            }
            return .requestErr(decodedData)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func isValidData(data: Data, responseData: ResponseData) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        switch responseData {
        case .addTag: return .success(AnyObject.self)
        case .deleteTag: return .success(AnyObject.self)
        case .getTag:
            guard let decodedData = try? decoder.decode(GetTagResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .addSubscriber: return .success(AnyObject.self)
        case .getSubscriber:
            guard let decodedData = try? decoder.decode(GetSubscriberResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .searchSubscriber:
            guard let decodedData = try? decoder.decode(SearchSubscriberResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .deleteSubscriber:
            guard let decodedData = try? decoder.decode(UnSubscribeResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .getSubscriberPosts:
            guard let decodedData = try? decoder.decode(GetSubscriberPostResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .getTagPosts:
            guard let decodedData = try? decoder.decode(GetTagPostResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .signIn:
            guard let decodedData = try? decoder.decode(SignInResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .signOut:
            guard let decodedData = try? decoder.decode(SignOutResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .signUp:
            guard let decodedData = try? decoder.decode(SignUpResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        case .broadCast:
            guard let decodedData = try? decoder.decode(BroadcastResponse.self, from: data) else {
                return .pathErr
            }
            return .success(decodedData)
        }
    }
}