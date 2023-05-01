//
//  SignUpResponse.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

struct SignUpResponse: Codable {
    var code: Int?
    var msg: String?
    var success: Bool?
}
