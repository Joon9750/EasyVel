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
            "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHJpbmciLCJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWF0IjoxNjgzOTUwNzE5LCJleHAiOjE3NjE3MTA3MTl9.maqGEhZ-AQKaCmOtuy6aNUlC476aARCen4Vp0VREaI4"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }
}
