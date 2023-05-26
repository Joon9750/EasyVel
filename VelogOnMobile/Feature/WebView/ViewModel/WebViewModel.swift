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
    
    var urlString: String = ""
    
    // MARK: - Output
    
    var urlRequest = PublishRelay<URLRequest>()
    
    init(url: String) {
        super.init()
        self.urlString = url
        makeOutput()
    }
    
    private func makeOutput() {
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                let urlString = "https://velog.io" + (self?.urlString ?? "")
                guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                let PostURL = URL(string: encodedStr)!
                self?.urlRequest.accept(URLRequest(url: PostURL))
            })
            .disposed(by: disposeBag)
    }
}
