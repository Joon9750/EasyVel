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
}

protocol SubscriberSearchViewModelInputOutput: SubscriberSearchViewModelInput, SubscriberSearchViewModelOutput {}

final class SubscriberSearchViewModel: SubscriberSearchViewModelInputOutput {
    
    // MARK: - Input
    
    func subscriberAddButtonDidTap(name: String) {
        addSubscriber(name: name) { [weak self] response in
            guard self != nil else {
                return
            }
        }
    }
}

private extension SubscriberSearchViewModel {
    func addSubscriber(name: String, completion: @escaping ([String]) -> Void) {
        NetworkService.shared.subscriberRepository.addSubscriber(fcmToken: "FCMToken", name: name) { result in
            switch result {
            case .success(let response):
                guard let list = response as? [String] else { return }
                completion(list)
            case .requestErr(let errResponse):
                dump(errResponse)
                // MARK: - 400, 예외처리
            default:
                print("error")
            }
        }
    }
}
