//
//  BaseTargetType.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {

    var baseURL: URL {
        return URL(string: BaseURLConstant.base)!
    }

    var headers: [String: String]? {
        let header = [
            "Content-Type": "application/json",
            "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHJpbmciLCJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWF0IjoxNjg1MjU4NjUyLCJleHAiOjE3NjMwMTg2NTJ9._GZBIngOvt1AK-bwlX8N8AKqBb6IcWrr40SXKIWVWAc"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }
}
