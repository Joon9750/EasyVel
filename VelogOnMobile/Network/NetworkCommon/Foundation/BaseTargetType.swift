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
            "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwaW5hZXgwMCIsInJvbGVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2ODU2Mjk4MDYsImV4cCI6MTc2MzM4OTgwNn0.4ke81ZKaH3cbT-k_YBveydvnZ072HgMbNZIFJcn0kkI"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }
}
