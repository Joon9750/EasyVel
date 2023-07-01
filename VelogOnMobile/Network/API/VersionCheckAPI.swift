//
//  VersionCheckAPO.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/07/01.
//

import Foundation

import Moya

enum VersionCheckAPI {
    case .versionCheck
}

extension VersionCheckAPI: BaseTargetType {
    var path: String {
        switch self {
        case .versionCheck:
            return URLConstants.versionCheck + "/version"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .versionCheck:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .versionCheck:
            return .requestPlain
        }
    }
}
