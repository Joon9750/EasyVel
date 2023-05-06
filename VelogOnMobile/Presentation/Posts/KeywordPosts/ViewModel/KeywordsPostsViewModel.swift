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
    // MARK: - fix me
    func cellDidTap(input: StoragePost)
}

protocol KeywordsPostsViewModelOutput {
    var tagPostsListOutput: ((GetTagPostResponse) -> Void)? { get set }
}

protocol KeywordsPostsViewModelInputOutput: KeywordsPostsViewModelInput, KeywordsPostsViewModelOutput {}

final class KeywordsPostsViewModel: KeywordsPostsViewModelInputOutput {
    
    let realm = RealmService()
    
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
    }
    
    func cellDidTap(input: StoragePost) {
        if checkIsUniquePost(post: input) {
            addPostRealm(post: input)
        }
    }
    
    // MARK: - Output
    
    var tagPostsListOutput: ((GetTagPostResponse) -> Void)?
    
    private func addPostRealm(post: StoragePost) {
        realm.addPost(item: post)
    }
    
    private func checkIsUniquePost(post: StoragePost) -> Bool {
        return realm.checkUniquePost(input: post)
    }
}

// MARK: - API

private extension KeywordsPostsViewModel {
    func getTagPostsForserver() {
        getTagPosts() { [weak self] result in
            self?.tagPosts = result
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
