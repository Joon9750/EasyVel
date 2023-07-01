//
//  DefaultCheckVersionRepository.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/07/01.
//

import Foundation

import Moya

final class DefaultCheckVersionRepository: BaseRepository, CheckVersionRepository {
    
    let provider = MoyaProvider<VersionCheckAPI>(plugins: [MoyaLoggerPlugin()])
    
    func getVersion(
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        provider.request(.versionCheck) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, responseData: .checkVersion)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
