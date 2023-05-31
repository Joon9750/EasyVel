//
//  SignInRequest.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

struct SignInRequest: Codable {
    var fcmToken:String?
    var id: String?
    var password: String?
}
