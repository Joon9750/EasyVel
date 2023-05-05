//
//  StorageViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/05.
//

import Foundation

import RealmSwift

protocol StorageViewModelInput {
    func deletePostButtonDidTap(url: String)
    func viewWillAppear()
}

protocol StorageViewModelOutput {
    var storagePosts: (([StoragePost]) -> Void)? { get set }
}

protocol StorageViewModelInputOutput: StorageViewModelInput, StorageViewModelOutput {}

final class StorageViewModel: StorageViewModelInputOutput {
    
    let realm = RealmService()

    // MARK: - Input
    
    func deletePostButtonDidTap(url: String) {
        realm.deletePost(url: url)
    }
    
    func viewWillAppear() {
        let realmPostData = realm.getPosts()
        let posts: [StoragePost] = convertToStoragePost(input: realmPostData)
        if let storagePosts = storagePosts {
            storagePosts(posts)
        }
    }
    
    // MARK: - Output
        
    var storagePosts: (([StoragePost]) -> Void)?
    
    // MARK: - func
    
    private func convertToStoragePost(input: Results<RealmStoragePost>) -> [StoragePost] {
        var storagePosts = [StoragePost]()
        let inputSize = input.count
        for index in 0..<inputSize {
            let post = StoragePost(
                img: input[index].img,
                name: input[index].name,
                summary: input[index].summary,
                title: input[index].title,
                url: input[index].url
            )
            storagePosts.append(post)
        }
        return storagePosts
    }
}
