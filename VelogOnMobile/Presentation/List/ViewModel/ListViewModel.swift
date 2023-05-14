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
    
    struct Output {
        var tagListOutput = PublishRelay<[String]>()
        var subscriberListOutput = PublishRelay<[String]>()
        var isListEmptyOutput = PublishRelay<Bool>()
    }
    
    // MARK: - Input
    
    struct Input {
        let tagDeleteButtonDidTap: Observable<String>
        let subscriberDeleteButtonDidTap: Observable<String>
    }
    
    // MARK: - func
    
    func transfrom(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let dispatchGroup = DispatchGroup()
                
                dispatchGroup.enter()
                self.getTagList() { [weak self] result in
                    self?.tagList = Array(result.reversed())
                    output.tagListOutput.accept(Array(result.reversed()))
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                self.getSubscriberList() { [weak self] result in
                    self?.subscriberList = Array(result.reversed())
                    output.subscriberListOutput.accept(Array(result.reversed()))
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main) { [weak self] in
                    let isListEmpty = self?.checkListIsEmpty(
                        tagList: self?.tagList ?? [String](),
                        subsciberList: self?.subscriberList ?? [String]()
                    )
                    output.isListEmptyOutput.accept(isListEmpty ?? Bool())
                }
            })
            .disposed(by: disposeBag)
        
        input.tagDeleteButtonDidTap
            .subscribe(onNext: { [weak self] tag in
                guard let self = self else { return }
                self.deleteTag(tag: tag) { [weak self] _ in
                    guard let self = self else { return }
                    self.getTagList() { [weak self] result in
                        self?.tagList = Array(result.reversed())
                    }
                    output.tagListOutput.accept(self.tagList)
                }
            })
            .disposed(by: disposeBag)
        
        input.subscriberDeleteButtonDidTap
            .subscribe(onNext: { [weak self] subscriber in
                guard let self = self else { return }
                self.deleteSubscriber(targetName: subscriber) { [weak self] _ in
                    guard let self = self else { return }
                    self.getSubscriberList() { [weak self] result in
                        self?.subscriberList = Array(result.reversed())
                    }
                    output.subscriberListOutput.accept(self.subscriberList)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func checkListIsEmpty(tagList: [String], subsciberList: [String]) -> Bool {
        if tagList.isEmpty && subsciberList.isEmpty {
            return true
        } else {
            return false
        }
    }
}

// MARK: - API

private extension ListViewModel {
    func getTagList(
        completion: @escaping ([String]) -> Void
    ) {
        NetworkService.shared.tagRepository.getTag() { result in
            switch result {
            case .success(let response):
                guard let list = response as? [String] else { return }
                completion(list)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
    
    func getSubscriberList(
        completion: @escaping ([String]) -> Void
    ) {
        NetworkService.shared.subscriberRepository.getSubscriber() { result in
            switch result {
            case .success(let response):
                guard let list = response as? [String] else { return }
                completion(list)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
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
