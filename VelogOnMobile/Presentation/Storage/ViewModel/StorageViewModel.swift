//
//  StorageViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/05.
//

import Foundation

import RealmSwift

protocol StorageViewModelInput {
    
    // MARK: - fix me
    func deletePostButtonDidTap(url: String)
    func viewWillAppear()
}

protocol StorageViewModelOutput {
    var storagePosts: (([StoragePost]) -> Void)? { get set }
    var isPostsEmpty: ((Bool) -> Void)? { get set }
}

protocol StorageViewModelInputOutput: StorageViewModelInput, StorageViewModelOutput {}

final class StorageViewModel: StorageViewModelInputOutput {

    let realm = RealmService()
    private var posts = [StoragePost]()

    // MARK: - Input
    
    func deletePostButtonDidTap(url: String) {
        deletePostInRealm(url: url)
        getPostInRealm()
        if let isPostsEmpty = isPostsEmpty {
            isPostsEmpty(checkStorageEmpty(storage: posts))
        }
    }
    
    func viewWillAppear() {
        getPostInRealm()
        if let isPostsEmpty = isPostsEmpty {
            isPostsEmpty(checkStorageEmpty(storage: posts))
        }
    }
    
    // MARK: - Output
        
    var storagePosts: (([StoragePost]) -> Void)?
    var isPostsEmpty: ((Bool) -> Void)?
    
    // MARK: - func
    
    private func getPostInRealm() {
        let realmPostData = realm.getPosts()
        let posts: [StoragePost] = realm.convertToStoragePost(input: realmPostData)
        let reversePosts = realm.reversePosts(input: posts)
        if let storagePosts = storagePosts {
            storagePosts(reversePosts)
        }
        self.posts = reversePosts
    }
    
    private func deletePostInRealm(url: String) {
        realm.deletePost(url: url)
    }
    
    private func checkStorageEmpty(storage: [StoragePost]) -> Bool {
        if storage.count == 0 { return true }
        else { return false }
    }
}
