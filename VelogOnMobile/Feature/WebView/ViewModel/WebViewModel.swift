//
//  WebViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/27.
//

import Foundation

import RxRelay
import RxSwift

final class WebViewModel: BaseViewModel {
    
    // MARK: - Output
    
    var urlRequest = PublishRelay<URLRequest>()
    
    // MARK: - Input
    
    var urlString = PublishRelay<String>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        urlString
            .filter { [weak self] response in
                return response.isValidURL
            }
            .subscribe(onNext: { [weak self] response in
                self?.urlRequest.accept(URLRequest(url: response))
            })
    }
}

fileprivate extension String {
    var isValidURL: Bool {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
