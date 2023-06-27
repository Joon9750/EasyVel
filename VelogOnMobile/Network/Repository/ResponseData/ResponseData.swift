//
//  ResponseData.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

@frozen
enum ResponseData {
    case addTag
    case deleteTag
    case getTag
    case addSubscriber
    case getSubscriber
    case searchSubscriber
    case deleteSubscriber
    case getSubscriberPosts
    case getTagPosts
    case signIn
    case signOut
    case signUp
    case broadCast
    case joinGroup
    case getPopularPosts
    case getSubscriberUserMain
    case trendPosts
}
