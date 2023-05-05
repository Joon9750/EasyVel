//
//  StoragePost.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/05.
//

import Foundation

struct StoragePost: Codable, Equatable {
    let img: String?
    let name: String?
    let summary: String?
    let title: String?
    let url: String?
}
