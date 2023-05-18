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

    // MARK: - Output
    
    var subscriberAddStatusOutput = PublishRelay<(Bool, String)>()
    
    // MARK: - Input
    
    let subscriberAddButtonDidTap = PublishRelay<String>()

    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillDisappear
            .flatMapLatest( { [weak self] _ -> Observable<[String]> in
                guard let self = self else { return Observable.empty() }
                return self.getSubscriberList()
            })
            .subscribe(onNext: { [weak self] list in
                self?.subscriberSearchDelegate?.searchSubscriberViewWillDisappear(input: list.reversed())
            })
            .disposed(by: disposeBag)
        
        subscriberAddButtonDidTap
            .flatMapLatest( { [weak self] name -> Observable<SearchSubscriberResponse> in
                guard let self = self else { return Observable.empty() }
                return self.searchSubscriber(name: name)
            })
            .filter { [weak self] response in
                if response.validate == false {
                    let text = TextLiterals.searchSubscriberIsNotValidText
                    self?.subscriberAddStatusOutput.accept((false, text))
                }
                return response.validate ?? false
            }
            .flatMapLatest( { [weak self] response -> Observable<Bool> in
                guard let self = self else { return Observable.empty() }
                return self.addSubscriber(name: response.userName ?? String())
            })
            .subscribe(onNext: { [weak self] response in
                if response {
                    let text = TextLiterals.addSubsriberSuccessText
                    self?.subscriberAddStatusOutput.accept((response, text))
                } else {
                    let text = TextLiterals.addSubscriberRequestErrText
                    self?.subscriberAddStatusOutput.accept((response, text))
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension SubscriberSearchViewModel {
    func searchSubscriber(name: String) -> Observable<SearchSubscriberResponse> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.searchSubscriber(name: name) { result in
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
    
    func addSubscriber(name: String) -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.addSubscriber(fcmToken: "FCMToken", name: name) { result in
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
    
    func getSubscriberList() -> Observable<[String]> {
        return Observable.create { observer in
            NetworkService.shared.subscriberRepository.getSubscriber() { result in
                switch result {
                case .success(let response):
                    guard let list = response as? [String] else {
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
