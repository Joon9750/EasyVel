//
//  PostsRepository.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

protocol PostsRepository {
    func getSubscriberPosts(completion: @escaping (NetworkResult<Any>) -> Void)
    func getTagPosts(completion: @escaping (NetworkResult<Any>) -> Void)
}
