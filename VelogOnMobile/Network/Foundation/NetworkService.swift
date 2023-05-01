//
//  NetworkService.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

final class NetworkService {
    
    static let shared = NetworkService()

    private init() {}
    
    let tagAPI = TagAPI()
    let subscriberAPI = SubscriberAPI()
    let postsAPI = PostsAPI()
    let signAPI = SignAPI()
    let notificationAPI = NotificationAPI()
}
