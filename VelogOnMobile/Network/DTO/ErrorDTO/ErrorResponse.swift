//
//  ErrorResponse.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

struct ErrorResponse: Codable {
    let timeStamp: String?
    let status: Int?
    let error: String?
    let path: String?
}
