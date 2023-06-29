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
        return URL(string: BaseURLConstant.base) ?? URL(fileURLWithPath: String())
    }

    var headers: [String: String]? {
        let accessToken = getTokenFromRealm()
        let header = [
            "Content-Type": "application/json",
            "X-AUTH-TOKEN": accessToken
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }
    
    private func getTokenFromRealm() -> String {
        let realm = RealmService()
        return realm.getAccessToken()
    }
}
