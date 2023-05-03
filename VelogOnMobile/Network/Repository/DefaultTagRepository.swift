//
//  TagAPI.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

final class DefaultTagRepository: BaseRepository, TagRepository {

    let provider = MoyaProvider<TagAPI>(plugins: [MoyaLoggerPlugin()])
    
    func addTag(
        tag: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.addTag(tag: tag)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .addTag)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteTag(
        tag: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.deleteTag(tag: tag)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .deleteTag)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getTag(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.getTag) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getTag)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
