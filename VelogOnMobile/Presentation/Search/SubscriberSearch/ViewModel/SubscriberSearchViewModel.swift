//
//  SubscriberSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

protocol SubscriberSearchViewModelInput {
    func subscriberAddButtonDidTap(name: String)
    func viewWillDisappear()
}

protocol SubscriberSearchViewModelOutput {
    var subscriberAddStatus: ((Bool, String) -> Void)? { get set }
}

protocol SubscriberSearchViewModelInputOutput: SubscriberSearchViewModelInput, SubscriberSearchViewModelOutput {}

final class SubscriberSearchViewModel: SubscriberSearchViewModelInputOutput {
    
    var subscriberSearchDelegate: SubscriberSearchProtocol?
    var subscriberList: [String]? {
        didSet {
            if let subscriberList = subscriberList {
                subscriberSearchDelegate?.searchSubscriberViewWillDisappear(input: subscriberList)
            }
        }
    }
    
    // MARK: - Output
    
    var subscriberAddStatus: ((Bool, String) -> Void)?
    
    // MARK: - Input
    
    func subscriberAddButtonDidTap(name: String) {
        searchSubsciber(name: name)
    }
    
    func viewWillDisappear() {
        getSubscribeListForServer()
    }
    
    private func searchSubsciber(name: String) {
        searchSubscriber(name: name) { [weak self] result in
            if let isValid = result.validate {
                if isValid {
                    self?.addSubscriber(name: name)
                    self?.joinSubscriberAlarmGroup(name: name)
                } else {
                    guard let subscriberAddStatus = self?.subscriberAddStatus else { return }
                    let text = TextLiterals.searchSubscriberIsNotValidText
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
        }
    }
    
    private func joinSubscriberAlarmGroup(name: String) {
        let joinGroupRequestData = JoinGroupRequest(groupName: name)
        joinAlarmGroup(subscriber: joinGroupRequestData) { [weak self] response in
            guard self != nil else {
                return
            }
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
                let text = TextLiterals.addSubsriberSuccessText
                subscriberAddStatus(true, text)
                completion("success")
            case .requestErr(let errResponse):
                guard let subscriberAddStatus = self?.subscriberAddStatus else { return }
                let text = TextLiterals.addSubscriberRequestErrText
                subscriberAddStatus(false, text)
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
    
    func joinAlarmGroup(
        subscriber: JoinGroupRequest,
        completion: @escaping (String) -> Void) {
        NetworkService.shared.notificationRepository.joinGroup(body: subscriber) { result in
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
    
    func getSubscribeListForServer() {
        self.getSubscriberList() { [weak self] response in
            guard let self = self else {
                return
            }
            self.subscriberList = Array(response.reversed())
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
