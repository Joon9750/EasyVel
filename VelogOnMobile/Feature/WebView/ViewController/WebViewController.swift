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
    
    var didScrap: Bool = false
    var didSubscribe: Bool = false
    var didScrapClosure: ((Bool) -> Void)?
    
    private let scrapButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.setImage(ImageLiterals.unSaveBookMarkIcon, for: .normal)
        button.isHidden = true
        return button
    }()
    private let subscriberButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 32)
        button.setTitle("구독", for: .normal)
        button.setTitleColor(UIColor.brandColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.brandColor.cgColor
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    lazy var firstButton = UIBarButtonItem(customView: self.scrapButton)
    lazy var secondButton = UIBarButtonItem(customView: self.subscriberButton)
    
    lazy var webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    override func render() {
        view = webView
    }
    
    override func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [firstButton, secondButton]
        super.setupNavigationBar()
    }
    
    override func bind(viewModel: WebViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: viewModel.webViewProgressRelay)
            .disposed(by: disposeBag)
        
        scrapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didScrap.toggle()
                if let didScrapClosure = self?.didScrapClosure,
                   let didScrap = self?.didScrap {
                    didScrapClosure(didScrap)
                }
                guard let didScrap = self?.didScrap else { return }
                let image = didScrap ? ImageLiterals.saveBookMarkIcon : ImageLiterals.unSaveBookMarkIcon
                self?.scrapButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        subscriberButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSubscribe.toggle()
                guard let didSubscribe = self?.didSubscribe else { return }
                if didSubscribe {
                    self?.subscriberButton.setTitleColor(UIColor.white, for: .normal)
                    self?.subscriberButton.backgroundColor = .brandColor
                    self?.showSubscibeToast(
                        toastText: "구독 했습니다.",
                        toastBackgroundColer: .brandColor
                    )
                    self?.viewModel?.didSubscribe.accept(true)
                } else {
                    self?.subscriberButton.setTitleColor(UIColor.brandColor, for: .normal)
                    self?.subscriberButton.backgroundColor = .white
                    self?.showSubscibeToast(
                        toastText: "구독 취소했습니다.",
                        toastBackgroundColer: .lightGray
                    )
                    self?.viewModel?.didSubscribe.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: WebViewModel) {
        viewModel.didSubscribeWriter
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] didSubscribed in
                self?.subscriberButton.isHidden = false
                self?.scrapButton.isHidden = false
                self?.setSubscribeButton(didSubscribe: didSubscribed)
            })
            .disposed(by: disposeBag)
            
        viewModel.urlRequestOutput
            .asDriver(onErrorJustReturn: URLRequest(url: URL(fileURLWithPath: "")))
            .drive(onNext: { [weak self] url in
                self?.webView.load(url)
            })
            .disposed(by: disposeBag)
        
        viewModel.webViewProgressOutput
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isProgressComplete in
                if isProgressComplete {
                    LoadingView.hideLoading()
                } else {
                    LoadingView.showLoading()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setSubscribeButton(
        didSubscribe: Bool
    ) {
        self.didSubscribe = didSubscribe
        if didSubscribe {
            self.subscriberButton.setTitleColor(UIColor.white, for: .normal)
            self.subscriberButton.backgroundColor = .brandColor
        } else {
            self.subscriberButton.setTitleColor(UIColor.brandColor, for: .normal)
            self.subscriberButton.backgroundColor = .white
        }
    }
    
    private func showSubscibeToast(
        toastText: String,
        toastBackgroundColer: UIColor
    ) {
        let toastLabel = UILabel()
        toastLabel.text = toastText
        toastLabel.textColor = .white
        toastLabel.font = UIFont(name: "Avenir-Black", size: 16)
        toastLabel.backgroundColor = toastBackgroundColer
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 24
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 1.0
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(51)
            $0.height.equalTo(48)
        }
        UIView.animate(withDuration: 0, animations: {
            toastLabel.alpha = 1.0
        }, completion: { isCompleted in
            UIView.animate(withDuration: 0.5, delay: 3.0, animations: {
                toastLabel.alpha = 0
            }, completion: { isCompleted in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
