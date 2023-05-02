//
//  NetworkService.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

final class NetworkService {
    
    static let shared = NetworkService()

    private init() {}
    
    let tagRepository = DefaultTagRepository()
    let subscriberRepository = DefaultSubscriberRepository()
    let postsRepository = DefaultPostsRepository()
    let signRepository = DefaultSignRepository()
    let notificationRepository = DefaultNotificationRepository()
}
