//
//  TagRepository.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

protocol TagRepository {
    func addTag(tag: String)
    func deleteTag(tag: String, completion: @escaping (NetworkResult<Any>) -> Void)
    func getTag(completion: @escaping (NetworkResult<Any>) -> Void)
}
