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
    
    private var urlString: String = ""
    
    // MARK: - Input
    
    let webViewProgressRelay = PublishRelay<Double>()
    
    // MARK: - Output
    
    var urlRequestOutput = PublishRelay<URLRequest>()
    var webViewProgressOutput = PublishRelay<Bool>()
    
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
                self?.urlRequestOutput.accept(URLRequest(url: PostURL))
            })
            .disposed(by: disposeBag)
        
        webViewProgressRelay
            .subscribe(onNext: { [weak self] progress in
                if progress < 0.8 {
                    self?.webViewProgressOutput.accept(false)
                } else {
                    self?.webViewProgressOutput.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
