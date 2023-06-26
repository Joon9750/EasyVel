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
    
    var subscriberList: [String] = [String]()
    var isListEmpty: Bool = Bool()
    
    // MARK: - Output

    var subscriberListOutput = PublishRelay<[SubscriberListResponse]>()
    var isListEmptyOutput = PublishRelay<Bool>()
    var subscriberUserMainURLOutput = PublishRelay<String>()
    
    // MARK: - Input
    
    let subscriberDeleteButtonDidTap = PublishRelay<String>()
    let refreshSubscriberList = PublishRelay<Bool>()
    let subscriberTableViewCellDidTap = PublishRelay<String>()
    
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
        
        subscriberDeleteButtonDidTap
            .subscribe(onNext: { [weak self] subscriber in
                guard let self = self else { return }
                self.deleteSubscriber(targetName: subscriber) { [weak self] _ in
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
    }
    
    private func getListData() {
        getSubscriberList()
            .map { Array($0.reversed()) }
            .subscribe(onNext: { [weak self] subscriberList in
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
            NetworkService.shared.subscriberRepository.getSubscriber() { result in
                switch result {
                case .success(let response):
                    guard let list = response as? [SubscriberListResponse] else { return }
                    observer.onNext(list)
                    observer.onCompleted()
                case .requestErr(let errResponse):
                    dump(errResponse)
                default:
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
        NetworkService.shared.subscriberRepository.deleteSubscriber(targetName: targetName){ result in
            switch result {
            case .success(_):
                completion("success")
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
    
    func getSubscriberUserMainURL(
        name: String,
        completion: @escaping (SubscriberUserMainResponse) -> Void
    ) {
        NetworkService.shared.subscriberRepository.getSubscriberUserMain(name: name) { result in
            switch result {
            case .success(let response):
                guard let url = response as? SubscriberUserMainResponse else { return }
                completion(url)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
}
