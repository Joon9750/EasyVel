//
//  SubscriberRepository.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

protocol SubscriberRepository {
    func addSubscriber(fcmToken: String, name: String, completion: @escaping (NetworkResult<Any>) -> Void)
    func getSubscriber(completion: @escaping (NetworkResult<Any>) -> Void)
    func searchSubscriber(name: String, completion: @escaping (NetworkResult<Any>) -> Void)
    func deleteSubscriber(targetName: String, completion: @escaping (NetworkResult<Any>) -> Void)
    func getSubscriberUserMain(name: String, completion: @escaping (NetworkResult<Any>) -> Void)
}
