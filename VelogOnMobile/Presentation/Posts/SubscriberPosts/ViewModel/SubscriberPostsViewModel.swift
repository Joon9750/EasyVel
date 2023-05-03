//
//  SubscriberPostsViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

protocol SubscriberPostsViewModelInput {
    func viewWillAppear()
}

protocol SubscriberPostsViewModelOutput {
    var subscriberPostsListOutput: ((GetSubscriberPostResponse) -> Void)? { get set }
}

protocol SubscriberPostsViewModelInputOutput: SubscriberPostsViewModelInput, SubscriberPostsViewModelOutput {}

final class SubscriberPostsViewModel: SubscriberPostsViewModelInputOutput {
    
    var subscribePosts: GetSubscriberPostResponse? {
        didSet {
            if let subscribePosts = subscribePosts,
               let subscriberPostsListOutput = subscriberPostsListOutput {
                subscriberPostsListOutput(subscribePosts)
            }
        }
    }
    
    // MARK: - Output
    
    var subscriberPostsListOutput: ((GetSubscriberPostResponse) -> Void)?
    
    // MARK: - Input
    
    func viewWillAppear() {
        getSubscriberPostsForserver()
    }
}

// MARK: - API

private extension SubscriberPostsViewModel {
    func getSubscriberPostsForserver() {
        getSubscriberPosts() { [weak self] result in
            self?.subscribePosts = result
        }
    }
    
    func getSubscriberPosts(completion: @escaping (GetSubscriberPostResponse) -> Void) {
        NetworkService.shared.postsRepository.getSubscriberPosts() { result in
            switch result {
            case .success(let response):
                guard let posts = response as? GetSubscriberPostResponse else { return }
                completion(posts)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
}
