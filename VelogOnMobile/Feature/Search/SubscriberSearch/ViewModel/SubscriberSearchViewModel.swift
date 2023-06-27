//
//  SubscriberSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

import RxRelay
import RxSwift

final class SubscriberSearchViewModel: BaseViewModel {
    
    var subscriberSearchDelegate: SubscriberSearchProtocol?
    var subscriberList: [SubscriberListResponse]?
    var searchSubscriberName: String?
    var searchSubscriberImageURL: String?

    // MARK: - Output
    
    var subscriberAddStatusOutput = PublishRelay<(Bool, String)>()
    
    // MARK: - Input
    
    let subscriberAddButtonDidTap = PublishRelay<String>()

    init(
        subscriberList: [SubscriberListResponse]?
    ) {
        super.init()
        self.subscriberList = subscriberList
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillDisappear
            .subscribe(onNext: { [weak self] in
                guard let subscriberList = self?.subscriberList else { return }
                self?.subscriberSearchDelegate?.searchSubscriberViewWillDisappear(subscriberList: subscriberList)
            })
            .disposed(by: disposeBag)
        
        subscriberAddButtonDidTap
            .flatMapLatest { [weak self] name -> Observable<SearchSubscriberResponse> in
                guard let self = self else { return Observable.empty() }
                return self.searchSubscriber(name: name)
            }
            .flatMapLatest { [weak self] response -> Observable<Bool> in
                guard let self = self else { return Observable.empty() }
                if response.validate == false {
                    let text = TextLiterals.searchSubscriberIsNotValidText
                    self.subscriberAddStatusOutput.accept((false, text))
                    return Observable.just(false)
                } else {
                    if let searchSubscriberName = response.userName,
                       let searchSubscriberImageURL = response.profilePictureURL {
                        self.searchSubscriberName = searchSubscriberName
                        self.searchSubscriberImageURL = searchSubscriberImageURL
                    }
                    return self.addSubscriber(name: response.userName ?? String())
                }
            }
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response {
                    self.subscriberAddStatusOutput.accept((response, TextLiterals.addSubsriberSuccessText))
                    guard let searchSubscriberName = self.searchSubscriberName else { return }
                    guard let searchSubscriberImageURL = self.searchSubscriberImageURL else { return }
                    self.addNewSubscriber(
                        searchSubscriberName: searchSubscriberName,
                        searchSubscriberImageURL: searchSubscriberImageURL
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addNewSubscriber(
        searchSubscriberName: String,
        searchSubscriberImageURL: String
    ) {
        let newSubscriber = SubscriberListResponse(
            img: searchSubscriberImageURL,
            name: searchSubscriberName
        )
        self.subscriberList?.insert(newSubscriber, at: 0)
    }
}

// MARK: - api

private extension SubscriberSearchViewModel {
    func searchSubscriber(
        name: String
    ) -> Observable<SearchSubscriberResponse> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.searchSubscriber(
                name: name
            ) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let result = response as? SearchSubscriberResponse else {
                        self?.serverFailOutput.accept(true)
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(result)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onCompleted()
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func addSubscriber(
        name: String
    ) -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.addSubscriber(
                fcmToken: "",
                name: name
            ) { [weak self] result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.subscriberAddStatusOutput.accept((false, TextLiterals.addSubscriberRequestErrText))
                    observer.onNext(false)
                    observer.onCompleted()
                default:
                    self?.subscriberAddStatusOutput.accept((false, TextLiterals.addSubscriberRequestErrText))
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
