//
//  SignInResponse.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

struct SignInResponse: Codable {
    let code: Int?
    let msg: String?
    let success: Bool?
    let token: String?
}
