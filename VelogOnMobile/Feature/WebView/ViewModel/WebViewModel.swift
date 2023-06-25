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
    private var isPostWebView: Bool = false
    private let realm = RealmService()
    var postWriter: String?
    var storagePost: StoragePost?
    
    // MARK: - Input
    
    let webViewProgressRelay = PublishRelay<Double>()
    let didSubscribe = PublishRelay<Bool>()
    let didUnScrap = PublishRelay<String>()
    
    // MARK: - Output
    
    var didSubscribeWriter = PublishRelay<Bool>()
    var urlRequestOutput = PublishRelay<URLRequest>()
    var webViewProgressOutput = PublishRelay<Bool>()
    
    init(
        url: String,
        isPostWebView: Bool
    ) {
        super.init()
        
        self.urlString = url
        self.isPostWebView = isPostWebView
        makeOutput()
    }
    
    private func makeOutput() {
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let webURL = self?.urlString else { return }
                guard let isPostWebView = self?.isPostWebView else { return }
                var urlString: String
                if isPostWebView {
                    urlString = TextLiterals.velogBaseURL + webURL
                } else {
                    urlString = webURL
                }
                guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                if let PostURL = URL(string: encodedStr) {
                    self?.urlRequestOutput.accept(URLRequest(url: PostURL))
                }
            })
            .disposed(by: disposeBag)
        
        viewWillAppear
            .flatMapLatest( { [weak self] _ -> Observable<[SubscriberListResponse]> in
                guard let self = self else { return Observable.empty() }
                return self.getSubscriberList()
            })
            .map { subscriberList -> [String] in
                return subscriberList.map { $0.name ?? String() }
            }
            .subscribe(onNext: { [weak self] subscriberNameList in
                guard let didPostWriterSubscribe = self?.didPostWriterSubscribe(
                    subscriberList: Set<String>(subscriberNameList),
                    postWriter: self?.postWriter ?? String()
                ) else { return }
                self?.didSubscribeWriter.accept(didPostWriterSubscribe)
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
        
        didSubscribe
            .subscribe(onNext: { [weak self] response in
                guard let subscriber = self?.postWriter else { return }
                if response {
                    self?.addSubscriber(name: subscriber)
                } else {
                    self?.deleteSubscriber(name: subscriber)
                }
            })
            .disposed(by: disposeBag)
        
        didUnScrap
            .subscribe(onNext: { [weak self] unScrapPostUrl in
                self?.realm.deletePost(url: unScrapPostUrl)
            })
            .disposed(by: disposeBag)
    }
    
    private func didPostWriterSubscribe(
        subscriberList: Set<String>,
        postWriter: String
    ) -> Bool {
        return subscriberList.contains(postWriter)
    }
}

extension WebViewModel {
    func addSubscriber(
        name: String
    ) {
        NetworkService.shared.subscriberRepository.addSubscriber(
            fcmToken: TextLiterals.noneText,
            name: name
        ) { result in
            switch result {
            case .success(_): break
            case .requestErr(_):
                print("error")
            default:
                print("error")
            }
        }
    }
    
    func deleteSubscriber(
        name: String
    ) {
        NetworkService.shared.subscriberRepository.deleteSubscriber(
            targetName: name
        ) { result in
            switch result {
            case .success(_): break
            case .requestErr(_):
                print("error")
            default:
                print("error")
            }
        }
    }
    
    func getSubscriberList() -> Observable<[SubscriberListResponse]> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.getSubscriber() { result in
                switch result {
                case .success(let response):
                    guard let list = response as? [SubscriberListResponse] else {
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(list)
                    observer.onCompleted()
                case .requestErr(let errResponse):
                    observer.onError(errResponse as! Error)
                default:
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
