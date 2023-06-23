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

    // MARK: - Output
    
    var subscriberAddStatusOutput = PublishRelay<(Bool, String)>()
    
    // MARK: - Input
    
    let subscriberAddButtonDidTap = PublishRelay<String>()

    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.subscribeToSubscriberList()
            })
            .disposed(by: disposeBag)
        
        viewWillDisappear
            .subscribe(onNext: { [weak self] in
                self?.subscriberSearchDelegate?.searchSubscriberViewWillDisappear()
            })
            .disposed(by: disposeBag)
        
        subscriberAddButtonDidTap
            .flatMapLatest { [weak self] name -> Observable<SearchSubscriberResponse> in
                guard let self = self else { return Observable.empty() }
                return self.searchSubscriber(name: name)
            }
            .filter { [weak self] response in
                guard let self = self else { return false }
                guard let addSubscriberName = response.userName else { return false }
                let subscriberNameList = self.subscriberList?.compactMap { $0.name }
                let isUniqueSubscriber = !(subscriberNameList?.contains(addSubscriberName) ?? true)
                if isUniqueSubscriber == false {
                    self.subscriberAddStatusOutput.accept((false, TextLiterals.addSubscriberRequestErrText))
                }
                return isUniqueSubscriber
            }
            .flatMapLatest { [weak self] response -> Observable<Bool> in
                guard let self = self else { return Observable.empty() }
                if response.validate == false {
                    let text = TextLiterals.searchSubscriberIsNotValidText
                    self.subscriberAddStatusOutput.accept((false, text))
                    return Observable.just(false)
                } else {
                    return self.addSubscriber(name: response.userName ?? String())
                }
            }
            .subscribe(onNext: { [weak self] response in
                let text: String
                if response {
                    text = TextLiterals.addSubsriberSuccessText
                    self?.subscribeToSubscriberList()
                } else {
                    text = TextLiterals.searchSubscriberIsNotValidText
                }
                self?.subscriberAddStatusOutput.accept((response, text))
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeToSubscriberList() {
        getSubscriberList()
            .subscribe(onNext: { [weak self] subscriberList in
                self?.subscriberList = subscriberList
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

private extension SubscriberSearchViewModel {
    func searchSubscriber(
        name: String
    ) -> Observable<SearchSubscriberResponse> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.searchSubscriber(
                name: name
            ) { result in
                switch result {
                case .success(let response):
                    guard let result = response as? SearchSubscriberResponse else {
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(result)
                    observer.onCompleted()
                case .requestErr(_):
                    observer.onCompleted()
                default:
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
            ) { result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .requestErr(_):
                    observer.onNext(false)
                    observer.onCompleted()
                default:
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
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
