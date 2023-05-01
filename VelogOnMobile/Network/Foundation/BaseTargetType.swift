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
            "X-AUTH-TOKEN": UserDefaults.standard.string(forKey: "OauthIdToken") ?? String()
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }
}
