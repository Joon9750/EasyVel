//
//  SearchSubscriberResponse.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

struct SearchSubscriberResponse: Codable {
    let profilePictureURL: String?
    let profileURL: String?
    let userName: String?
    let validate: Bool?
}
