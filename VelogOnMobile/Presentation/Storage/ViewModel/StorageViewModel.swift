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
}

protocol StorageViewModelInputOutput: StorageViewModelInput, StorageViewModelOutput {}

final class StorageViewModel: StorageViewModelInputOutput {
    
    let realm = RealmService()

    // MARK: - Input
    
    func deletePostButtonDidTap(url: String) {
        deletePostInRealm(url: url)
        getPostInRealm()
    }
    
    func viewWillAppear() {
        getPostInRealm()
    }
    
    // MARK: - Output
        
    var storagePosts: (([StoragePost]) -> Void)?
    
    // MARK: - func
    
    private func getPostInRealm() {
        let realmPostData = realm.getPosts()
        let posts: [StoragePost] = realm.convertToStoragePost(input: realmPostData)
        if let storagePosts = storagePosts {
            storagePosts(posts)
        }
    }
    
    private func deletePostInRealm(url: String) {
        realm.deletePost(url: url)
    }
}
