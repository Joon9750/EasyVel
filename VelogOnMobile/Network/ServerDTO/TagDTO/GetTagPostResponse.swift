//
//  GetTapPostRespnose.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

struct GetTagPostResponse: Codable {
    let tagPostDtoList: [TagPostDtoList]?
}

struct TagPostDtoList: Codable {
    let comment: Int?
    let date: String?
    let img: String?
    let like: Int?
    let name: String?
    let summary: String?
    let tag: [String]?
    let title: String?
    let url: String?
}

