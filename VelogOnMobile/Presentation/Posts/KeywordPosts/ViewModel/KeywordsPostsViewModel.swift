//
//  KeywordsPostsViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

protocol KeywordsPostsViewModelInput {
    func viewWillAppear()
}

protocol KeywordsPostsViewModelOutput {
    var tagPostsListOutput: ((GetTagPostResponse) -> Void)? { get set }
}

protocol KeywordsPostsViewModelInputOutput: KeywordsPostsViewModelInput, KeywordsPostsViewModelOutput {}

final class KeywordsPostsViewModel: KeywordsPostsViewModelInputOutput {
    
    var tagPosts: GetTagPostResponse? {
        didSet {
            if let tagPosts = tagPosts,
               let tagPostsListOutput = tagPostsListOutput {
                tagPostsListOutput(tagPosts)
            }
        }
    }
    
    // MARK: - Output
    
    var tagPostsListOutput: ((GetTagPostResponse) -> Void)?
    
    // MARK: - Input
    
    func viewWillAppear() {
        getTagPostsForserver()
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
