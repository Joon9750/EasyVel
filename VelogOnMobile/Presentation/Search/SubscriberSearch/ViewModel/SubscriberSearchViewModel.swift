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
        addSubscriber(name: name)
    }
}

private extension SubscriberSearchViewModel {
    func addSubscriber(name: String) {
        NetworkService.shared.subscriberRepository.addSubscriber(fcmToken: "FCMToken", name: name)
    }
}
