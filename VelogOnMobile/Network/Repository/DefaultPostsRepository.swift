//
//  PostsAPI.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

import Moya

final class DefaultPostsRepository: BaseRepository, PostsRepository {
    
    let provider = MoyaProvider<PostsAPI>(plugins: [MoyaLoggerPlugin()])
    
    func getSubscriberPosts(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.getSubscriberPosts) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getSubscriberPosts)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getTagPosts(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.getTagPosts) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getTagPosts)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getPopularPosts(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.getPopularPosts) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .getPopularPosts)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
