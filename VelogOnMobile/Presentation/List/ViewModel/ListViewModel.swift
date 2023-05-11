//
//  ListViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

protocol ListViewModelInput {
    func viewWillAppear()
    func tagDeleteButtonDidTap(tag: String)
    func subscriberDeleteButtonDidTap(target: String)
}

protocol ListViewModelOutput {
    var tagListOutput: (([String]) -> Void)? { get set }
    var subscriberListOutput: (([String]) -> Void)? { get set }
}

protocol ListViewModelInputOutput: ListViewModelInput, ListViewModelOutput {}

final class ListViewModel: ListViewModelInputOutput {
        
    var tagList: [String]? {
        didSet {
            if let tagListOutput = tagListOutput,
               let tagList = tagList {
                tagListOutput(tagList)
            }
        }
    }
    
    var subscriberList: [String]? {
        didSet {
            if let subscriberListOutput = subscriberListOutput,
               let subscriberList = subscriberList {
                subscriberListOutput(subscriberList)
            }
        }
    }
    
    // MARK: - Output
    
    var tagListOutput: (([String]) -> Void)?
    var subscriberListOutput: (([String]) -> Void)?
    
    // MARK: - Input
    
    func viewWillAppear() {
        getTagListForServer()
        getSubscribeListForServer()
    }
    
    func tagDeleteButtonDidTap(tag: String) {
        deleteTag(tag: tag) { [weak self] response in
            guard let self = self else {
                return
            }
            self.getTagListForServer()
            self.getSubscribeListForServer()
        }
    }
    
    func subscriberDeleteButtonDidTap(target: String) {
        deleteSubscriber(targetName: target) { [weak self] response in
            guard let self = self else {
                return
            }
            self.getTagListForServer()
            self.getSubscribeListForServer()
        }
    }
}

// MARK: - API

private extension ListViewModel {
    func getTagListForServer() {
        self.getTagList() { [weak self] response in
            guard let self = self else {
                return
            }
            self.tagList = Array(response.reversed())
        }
    }
    
    func getSubscribeListForServer() {
        self.getSubscriberList() { [weak self] response in
            guard let self = self else {
                return
            }
            self.subscriberList = Array(response.reversed())
        }
    }
    
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
