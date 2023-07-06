//
//  ListViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxRelay
import RxSwift

final class ListViewModel: BaseViewModel {
    
    var subscriberList: [SubscriberListResponse]?
    var isListEmpty: Bool = Bool()
    var tempDeleteSubscriber: String?
    
    // MARK: - Output

    var subscriberListOutput = PublishRelay<[SubscriberListResponse]>()
    var isListEmptyOutput = PublishRelay<Bool>()
    var subscriberUserMainURLOutput = PublishRelay<String>()
    var presentUnsubscribeAlertOutput = PublishRelay<Bool>()
    
    // MARK: - Input
    
    let refreshSubscriberList = PublishRelay<Bool>()
    let subscriberTableViewCellDidTap = PublishRelay<String>()
    let unsubscriberButtonDidTap = PublishRelay<String>()
    let deleteSubscribeEvent = PublishRelay<Void>()
    
    // MARK: - init
    
    override init() {
        super.init()
        makeOutput()
    }
    
    // MARK: - func
    
    private func makeOutput() {
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.getListData()
            })
            .disposed(by: disposeBag)
        
        deleteSubscribeEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let tempDeleteSubscriber = tempDeleteSubscriber else { return }
                if let subscriberList = self.subscriberList {
                    let reloadSubscriberList = subscriberList.filter {
                        $0.name != tempDeleteSubscriber
                    }
                    self.subscriberList = reloadSubscriberList
                    self.subscriberListOutput.accept(reloadSubscriberList)
                }
                self.deleteSubscriber(targetName: tempDeleteSubscriber) { [weak self] _ in
                    self?.getListData()
                }
            })
            .disposed(by: disposeBag)
        
        refreshSubscriberList
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.getListData()
            })
            .disposed(by: disposeBag)
        
        subscriberTableViewCellDidTap
            .subscribe(onNext: { [weak self] subscriberName in
                guard let self = self else { return }
                self.getSubscriberUserMainURL(
                    name: subscriberName
                ) { [weak self] subscriberUserMainURLString in
                    guard let userMainURL = subscriberUserMainURLString.userMainUrl else { return }
                    self?.subscriberUserMainURLOutput.accept(userMainURL)
                }
            })
            .disposed(by: disposeBag)
        
        unsubscriberButtonDidTap
            .subscribe { name in
                self.tempDeleteSubscriber = name
                self.presentUnsubscribeAlertOutput.accept(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func getListData() {
        getSubscriberList()
            .map { Array($0.reversed()) }
            .subscribe(onNext: { [weak self] subscriberList in
                self?.subscriberList = subscriberList
                self?.subscriberListOutput.accept(subscriberList)
                let subscriberNameList = subscriberList.map { $0.name ?? String() }
                self?.checkListIsEmpty(subsciberList: subscriberNameList)
            })
            .disposed(by: disposeBag)
    }
    
    private func checkListIsEmpty(
        subsciberList: [String]
    ) {
        if subsciberList.isEmpty == true {
            isListEmptyOutput.accept(true)
        } else {
            isListEmptyOutput.accept(false)
        }
    }
}

// MARK: - API

private extension ListViewModel {
    func getSubscriberList() -> Observable<[SubscriberListResponse]> {
        return Observable.create { observer -> Disposable in
            NetworkService.shared.subscriberRepository.getSubscriber() { [weak self] result in
                switch result {
                case .success(let response):
                    guard let list = response as? [SubscriberListResponse] else {
                        self?.serverFailOutput.accept(true)
                        return
                    }
                    observer.onNext(list)
                    observer.onCompleted()
                case .requestErr(let errResponse):
                    self?.serverFailOutput.accept(true)
                    dump(errResponse)
                default:
                    self?.serverFailOutput.accept(true)
                    print("error")
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteSubscriber(
        targetName: String,
        completion: @escaping (String) -> Void
    ) {
        NetworkService.shared.subscriberRepository.deleteSubscriber(
            targetName: targetName
        ){ [weak self] result in
            switch result {
            case .success(_):
                completion("success")
            case .requestErr(let errResponse):
                self?.serverFailOutput.accept(true)
                dump(errResponse)
            default:
                self?.serverFailOutput.accept(true)
                print("error")
            }
        }
    }
    
    func getSubscriberUserMainURL(
        name: String,
        completion: @escaping (SubscriberUserMainResponse) -> Void
    ) {
        NetworkService.shared.subscriberRepository.getSubscriberUserMain(
            name: name
        ) { [weak self] result in
            switch result {
            case .success(let response):
                guard let url = response as? SubscriberUserMainResponse else {
                    self?.serverFailOutput.accept(true)
                    return
                }
                completion(url)
            case .requestErr(let errResponse):
                self?.serverFailOutput.accept(true)
                dump(errResponse)
            default:
                self?.serverFailOutput.accept(true)
                print("error")
            }
        }
    }
}
