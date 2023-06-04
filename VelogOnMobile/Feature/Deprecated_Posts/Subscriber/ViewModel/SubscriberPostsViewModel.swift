//
//  SubscriberPostsViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

import RealmSwift

protocol SubscriberPostsViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func cellDidTap(input: StoragePost)
    func tableViewReload()
}

protocol SubscriberPostsViewModelOutput {
    var subscriberPostsListOutput: ((GetSubscriberPostResponse) -> Void)? { get set }
    var toastPresent: ((Bool) -> Void)? { get set }
    var isPostsEmpty: ((Bool) -> Void)? { get set }
}

protocol SubscriberPostsViewModelInputOutput: SubscriberPostsViewModelInput, SubscriberPostsViewModelOutput {}

final class SubscriberPostsViewModel: SubscriberPostsViewModelInputOutput {

    let realm = RealmService()
    
    var subscribePosts: GetSubscriberPostResponse? {
        didSet {
            if let subscribePosts = subscribePosts,
               let subscriberPostsListOutput = subscriberPostsListOutput {
                subscriberPostsListOutput(subscribePosts)
            }
        }
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        LoadingView.showLoading()
    }
    
    func viewWillAppear() {
        getSubscriberPostsForserver()
    }
    
    func cellDidTap(input: StoragePost) {
        if checkIsUniquePost(post: input) {
            // MARK: - fix me : articleID 일단 기본 0
            addPostRealm(post: input, folderName: "모든 게시글")
            toastSuccessPresentOutPut()
        } else {
            toastFailPresentOutPut()
        }
    }
    
    func tableViewReload() {
        LoadingView.showLoading()
        getSubscriberPostsForserver()
    }
    
    // MARK: - Output
    
    var subscriberPostsListOutput: ((GetSubscriberPostResponse) -> Void)?
    var toastPresent: ((Bool) -> Void)?
    var isPostsEmpty: ((Bool) -> Void)?
    
    // MARK: - func
    
    private func addPostRealm(post: StoragePost, folderName: String) {
        realm.addPost(item: post, folderName: folderName)
    }
    
    private func checkIsUniquePost(post: StoragePost) -> Bool {
        return realm.checkUniquePost(input: post)
    }
    
    private func toastFailPresentOutPut() {
        if let toastPresent = toastPresent {
            toastPresent(false)
        }
    }
    
    private func toastSuccessPresentOutPut() {
        if let toastPresent = toastPresent {
            toastPresent(true)
        }
    }
    
    private func checkPostsEmpty(input: GetSubscriberPostResponse) -> Bool {
        if input.subscribePostDtoList == nil { return true }
        else { return false }
    }
}

// MARK: - API

private extension SubscriberPostsViewModel {
    func getSubscriberPostsForserver() {
        getSubscriberPosts() { [weak self] result in
            self?.subscribePosts = result
            if let isPostsEmpty = self?.isPostsEmpty {
                isPostsEmpty((self?.checkPostsEmpty(input: result))!)
            }
            LoadingView.hideLoading()
        }
    }
    
    func getSubscriberPosts(
        completion: @escaping (GetSubscriberPostResponse) -> Void
    ) {
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