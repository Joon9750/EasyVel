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
    
    var tagList: [String] = [String]()
    var subscriberList: [String] = [String]()
    var isListEmpty: Bool = Bool()
    
    // MARK: - Output

    var tagListOutput = PublishRelay<[String]>()
    var subscriberListOutput = PublishRelay<[String]>()
    var isListEmptyOutput = PublishRelay<Bool>()
    
    // MARK: - Input
    
    let tagDeleteButtonDidTap = PublishRelay<String>()
    let subscriberDeleteButtonDidTap = PublishRelay<String>()
    
    // MARK: - init
    
    override init() {
        super.init()
        makeOutput()
    }
    
    // MARK: - func
    
    private func makeOutput() {
        viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.getListData()
            })
            .disposed(by: disposeBag)
        
        tagDeleteButtonDidTap
            .subscribe(onNext: { [weak self] tag in
                guard let self = self else { return }
                self.deleteTag(tag: tag) { [weak self] _ in
                    self?.getListData()
                }
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
    }
    
    private func getListData() {
        
        let tagListObservable = getTagList().map { Array($0.reversed()) }
        let subscriberListObservable = getSubscriberList().map { Array($0.reversed()) }
        
        Observable.combineLatest(tagListObservable, subscriberListObservable)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (tagList, subscriberList) in
                self?.tagListOutput.accept(tagList)
                self?.subscriberListOutput.accept(subscriberList)
                self?.checkListIsEmpty(tagList: tagList, subsciberList: subscriberList)
            })
            .disposed(by: disposeBag)
    }
    
    private func checkListIsEmpty(tagList: [String], subsciberList: [String]) {
        if tagList.isEmpty == true && subsciberList.isEmpty == true {
            isListEmptyOutput.accept(true)
        } else {
            isListEmptyOutput.accept(false)
        }
    }
}

// MARK: - API

private extension ListViewModel {
    func getTagList() -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            NetworkService.shared.tagRepository.getTag() { result in
                switch result {
                case .success(let response):
                    guard let list = response as? [String] else { return }
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
    
    func getSubscriberList() -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            NetworkService.shared.subscriberRepository.getSubscriber() { result in
                switch result {
                case .success(let response):
                    guard let list = response as? [String] else { return }
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
    
    func deleteTag(
        tag: String,
        completion: @escaping (String) -> Void
    ) {
        NetworkService.shared.tagRepository.deleteTag(tag: tag) { result in
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
}
