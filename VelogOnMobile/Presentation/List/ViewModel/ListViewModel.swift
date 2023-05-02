//
//  ListViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

protocol ListViewModelInput {
    func viewWillAppear()
}

protocol ListViewModelOutput {
    var tagListOutput: (([String]) -> Void)? { get set }
    var subscriberListOutput: (([String]) -> Void)? { get set }
}

protocol ListViewModelInputOutput: ListViewModelInput, ListViewModelOutput {}

final class ListViewModel: ListViewModelInputOutput {
    
    var tagList: [String]? {
        didSet {
            if let tagListOutput,
               let tagList {
                tagListOutput(tagList)
            }
        }
    }
    
    var subscriberList: [String]? {
        didSet {
            if let subscriberListOutput,
               let subscriberList {
                subscriberListOutput(subscriberList)
            }
        }
    }
    
    // MARK: - Output
    
    var tagListOutput: (([String]) -> Void)?
    var subscriberListOutput: (([String]) -> Void)?
}

// MARK: - Input

extension ListViewModel {
    func viewWillAppear() {
        getTagListForServer()
        getSubscribeListForServer()
    }
}

private extension ListViewModel {
    
    func getTagListForServer() {
        self.getTagList() { [weak self] response in
            guard let self = self else {
                return
            }
            print(response)
            self.tagList = response
        }
    }
    
    func getSubscribeListForServer() {
        self.getSubscriberList() { [weak self] response in
            guard let self = self else {
                return
            }
            print(response)
            self.subscriberList = response
        }
    }
    
    func getTagList(completion: @escaping ([String]) -> Void) {
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
    
    func getSubscriberList(completion: @escaping ([String]) -> Void) {
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
}
