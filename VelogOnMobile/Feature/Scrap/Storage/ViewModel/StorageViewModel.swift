//
//  StorageViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/05.
//

import Foundation

import RealmSwift
import RxRelay
import RxSwift

final class StorageViewModel: BaseViewModel {

    let realm = RealmService()
    var folderName: String?

    // MARK: - Input
    
    var deletePostButtonDidTap = PublishRelay<String>()
    var deleteFolderButtonDidTap = PublishRelay<Bool>()
    var changeFolderButtonDidTap = PublishRelay<([StoragePost], String)>()
    
    // MARK: - Output
    
    var storagePostsOutput = PublishRelay<[StoragePost]>()
    var isPostsEmptyOutput = PublishRelay<Bool>()
    var folderNameOutput = PublishRelay<String>()
    var newFolderNameIsUniqueOutput = PublishRelay<(String, Bool)>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                let realmData = self?.getFolderPostInRealm(folderName: self?.folderName ?? "")
                self?.storagePostsOutput.accept(realmData ?? [StoragePost]())
                let isEmpty = self?.checkStorageEmpty(storage: realmData ?? [StoragePost]())
                self?.isPostsEmptyOutput.accept(isEmpty ?? Bool())
                self?.folderNameOutput.accept(self?.folderName ?? String())
            })
            .disposed(by: disposeBag)
        
        deletePostButtonDidTap
            .subscribe(onNext: { [weak self] url in
                self?.realm.deletePost(url: url)
                let folderRealmData = self?.getFolderPostInRealm(folderName: self?.folderName ?? "")
                let isfolderEmpty = self?.checkStorageEmpty(storage: folderRealmData ?? [StoragePost]())
                self?.isPostsEmptyOutput.accept(isfolderEmpty ?? Bool())
                self?.storagePostsOutput.accept(folderRealmData ?? [StoragePost]())
            })
            .disposed(by: disposeBag)
        
        deleteFolderButtonDidTap
            .subscribe(onNext: { [weak self] didFolderDelete in
                if didFolderDelete {
                    self?.realm.deleteFolder(folderName: self?.folderName ?? String())
                }
            })
            .disposed(by: disposeBag)
        
        changeFolderButtonDidTap
            .subscribe(onNext: { [weak self] storagePosts, changeFolderName in
                guard let oldFolderName = self?.folderName else { return }
                guard let isNewFolderNameUnique = self?.checkIsUniqueFolderName(newFolderName: changeFolderName) else {
                    return
                }
                if changeFolderName == "" {
                    return
                }
                if isNewFolderNameUnique {
                    self?.newFolderNameIsUniqueOutput.accept(
                        (changeFolderName, true)
                    )
                    self?.realm.changeFolderNameInStorage(
                        input: storagePosts,
                        oldFolderName: oldFolderName,
                        newFolderName: changeFolderName
                    )
                } else {
                    self?.newFolderNameIsUniqueOutput.accept(
                        (changeFolderName, false)
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - func
    
    private func checkIsUniqueFolderName(
        newFolderName: String
    ) -> Bool {
        let isUniqueFolderName = self.realm.checkUniqueFolderName(
            newFolderName: newFolderName
        )
        return isUniqueFolderName
    }
    
    private func getPostInRealm() -> [StoragePost] {
        let realmPostData = realm.getPosts()
        let posts: [StoragePost] = realm.convertToStoragePost(input: realmPostData)
        let reversePosts = realm.reversePosts(input: posts)
        return reversePosts
    }
    
    private func getFolderPostInRealm(
        folderName: String
    ) -> [StoragePost] {
        let realmPostData = realm.getFolderPosts(folderName: folderName)
        let posts: [StoragePost] = realm.convertToStoragePost(input: realmPostData)
        let reversePosts = realm.reversePosts(input: posts)
        return reversePosts
    }

    private func checkStorageEmpty(
        storage: [StoragePost]
    ) -> Bool {
        if storage.count == 0 { return true }
        else { return false }
    }
}
