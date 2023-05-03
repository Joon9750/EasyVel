//
//  SubscriberSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

protocol SubscriberSearchViewModelInput {
    func subscriberAddButtonDidTap(name: String)
}

protocol SubscriberSearchViewModelOutput {
    var subscriberAddStatus: ((Bool, String) -> Void)? { get set }
}

protocol SubscriberSearchViewModelInputOutput: SubscriberSearchViewModelInput, SubscriberSearchViewModelOutput {}

final class SubscriberSearchViewModel: SubscriberSearchViewModelInputOutput {
    
    // MARK: - Output
    
    var subscriberAddStatus: ((Bool, String) -> Void)?
    
    // MARK: - Input
    
    func subscriberAddButtonDidTap(name: String) {
        searchSubsciber(name: name)
    }
    
    private func searchSubsciber(name: String) {
        searchSubscriber(name: name) { [weak self] result in
            if let isValid = result.validate {
                if isValid {
                    self?.addSubscriber(name: name)
                } else {
                    guard let subscriberAddStatus = self?.subscriberAddStatus else { return }
                    let text = "없는 사용자입니다."
                    subscriberAddStatus(false, text)
                }
            }
        }
    }
    
    private func addSubscriber(name: String) {
        addSubscriber(name: name) { [weak self] response in
            guard self != nil else {
                return
            }
            print("this is my response : ", response)
        }
    }
}

private extension SubscriberSearchViewModel {
    func searchSubscriber(name: String, completion: @escaping (SearchSubscriberResponse) -> Void) {
        NetworkService.shared.subscriberRepository.searchSubscriber(name: name) { result in
            switch result {
            case .success(let response):
                guard let result = response as? SearchSubscriberResponse else { return }
                completion(result)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
    
    func addSubscriber(name: String, completion: @escaping (String) -> Void) {
        NetworkService.shared.subscriberRepository.addSubscriber(fcmToken: "FCMToken", name: name) { [weak self] result in
            switch result {
            case .success(_):
                guard let subscriberAddStatus = self?.subscriberAddStatus else { return }
                let text = "구독자 추가되었습니다."
                subscriberAddStatus(true, text)
                completion("success")
            case .requestErr(let errResponse):
                guard let subscriberAddStatus = self?.subscriberAddStatus else { return }
                let text = "이미 추가한 구독자입니다."
                subscriberAddStatus(false, text)
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
}
