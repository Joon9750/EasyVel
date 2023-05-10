//
//  KeywordsPostsViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import Foundation

import RealmSwift

protocol KeywordsPostsViewModelInput {
    func viewWillAppear()
    func cellDidTap(input: StoragePost)
    func tableViewReload()
    func viewControllerDidScroll()
    func viewControllerScrollDidEnd()
}

protocol KeywordsPostsViewModelOutput {
    var tagPostsListOutput: ((GetTagPostResponse) -> Void)? { get set }
    var toastPresent: ((Bool) -> Void)? { get set }
    var isPostsEmpty: ((Bool) -> Void)? { get set }
    var scrollToTop: ((Bool) -> Void)? { get set }
}

protocol KeywordsPostsViewModelInputOutput: KeywordsPostsViewModelInput, KeywordsPostsViewModelOutput {}

final class KeywordsPostsViewModel: KeywordsPostsViewModelInputOutput {
    
    let realm = RealmService()
    var postViewDelegate: PostsViewControllerProtocol?
    
    var tagPosts: GetTagPostResponse? {
        didSet {
            if let tagPosts = tagPosts,
               let tagPostsListOutput = tagPostsListOutput {
                tagPostsListOutput(tagPosts)
            }
        }
    }
    
    // MARK: - Input
    
    func viewWillAppear() {
        getTagPostsForserver()
        if let scrollToTop = scrollToTop {
            scrollToTop(true)
        }
    }
    
    func cellDidTap(input: StoragePost) {
        if checkIsUniquePost(post: input) {
            addPostRealm(post: input)
            toastSuccessPresentOutPut()
        } else {
            toastFailPresentOutPut()
        }
    }
    
    func tableViewReload() {
        LoadingView.showLoading()
        getTagPostsForserver()
    }
    
    func viewControllerDidScroll() {
        postViewDelegate?.postsViewScrollDidStart()
    }
    
    func viewControllerScrollDidEnd() {
        postViewDelegate?.postsViewScrollDidEnd()
    }
    
    // MARK: - Output
    
    var tagPostsListOutput: ((GetTagPostResponse) -> Void)?
    var toastPresent: ((Bool) -> Void)?
    var isPostsEmpty: ((Bool) -> Void)?
    var scrollToTop: ((Bool) -> Void)?
    
    // MARK: - func

    private func addPostRealm(post: StoragePost) {
        realm.addPost(item: post)
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
    
    private func checkStorageEmpty(input: GetTagPostResponse) -> Bool {
        if input.tagPostDtoList == nil { return true }
        else { return false }
    }
}

// MARK: - API

private extension KeywordsPostsViewModel {
    func getTagPostsForserver() {
        getTagPosts() { [weak self] result in
            self?.tagPosts = result
            if let isPostsEmpty = self?.isPostsEmpty {
                isPostsEmpty((self?.checkStorageEmpty(input: result))!)
            }
            LoadingView.hideLoading()
        }
    }
    
    func getTagPosts(completion: @escaping (GetTagPostResponse) -> Void) {
        NetworkService.shared.postsRepository.getTagPosts() { result in
            switch result {
            case .success(let response):
                guard let posts = response as? GetTagPostResponse else { return }
                completion(posts)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
}
