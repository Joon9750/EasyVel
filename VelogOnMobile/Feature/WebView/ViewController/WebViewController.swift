//
//  WebViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit
import WebKit

import RxCocoa
import RxSwift

final class WebViewController: RxBaseViewController<WebViewModel> {
    
    lazy var webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private let webViewProgressRelay = PublishRelay<Double>()
    
    override func render() {
        view = webView
    }
    
    override func bind(viewModel: WebViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: webViewProgressRelay)
            .disposed(by: disposeBag)
        
        webViewProgressRelay
            .subscribe(onNext: { [weak self] progress in
                self?.updateLoadingIndicator(progress: progress)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: WebViewModel) {
        viewModel.urlRequest
            .asDriver(onErrorJustReturn: URLRequest(url: URL(fileURLWithPath: "")))
            .drive(onNext: { [weak self] url in
                self?.webView.load(url)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = TextLiterals.noneText
    }
    
    func updateLoadingIndicator(progress: Double) {
        if progress < 0.8 {
            LoadingView.showLoading()
        } else {
            LoadingView.hideLoading()
        }
    }
}
