//
//  AuthResponse.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

struct SignUpRequest: Codable {
    var id: String?
    var name: String?
    var password: String?
    var role: String?
}
