//
//  RealmService.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/05.
//

import Foundation

import RealmSwift
import Realm

final class RealmService {
    
    private let localRealm = try! Realm()
    
    func setAccessToken(
        accessToken: String
    ) {
        guard let object = localRealm.objects(AccessTokenDTO.self).first else {
            let firstAccessToken = AccessTokenDTO(input: accessToken)
            try! localRealm.write {
                localRealm.add(firstAccessToken)
            }
            return
        }
        try! localRealm.write {
            object.accessToken = accessToken
        }
    }
    
    func getAccessToken() -> String {
        guard let object = localRealm.objects(AccessTokenDTO.self).first else {
            return ""
        }
        guard let token = object.accessToken else { return "" }
        return token
    }
    
    func setAutoSignIn(
        didSignIn: Bool
    ) {
        guard let object = localRealm.objects(AutoSignInDTO.self).first else {
            let firstAutoSignIn = AutoSignInDTO(input: true)
            try! localRealm.write {
                localRealm.add(firstAutoSignIn)
            }
            return
        }
        if didSignIn {
            try! localRealm.write {
                object.didSignIn = true
            }
        } else {
            try! localRealm.write {
                object.didSignIn = false
            }
        }
    }
    
    func checkIsUserSignIn() -> Bool {
        guard let object = localRealm.objects(AutoSignInDTO.self).first else { return false }
        guard let didSignIn = object.didSignIn else { return false }
        return didSignIn
    }
    
    func addPost(
        item: StoragePost,
        folderName: String
    ) {
        let post = RealmStoragePost(input: item, folderName: folderName)
        if localRealm.isEmpty {
            try! localRealm.write {
                localRealm.add(post)
            }
        } else {
            try! localRealm.write {
                localRealm.add(post, update: .modified)
            }
        }
    }
    
    func addFolder(
        item: StorageDTO
    ) {
        let folder = ScrapStorageDTO(input: item)
        if localRealm.isEmpty {
            try! localRealm.write {
                localRealm.add(folder)
            }
        } else {
            try! localRealm.write {
                localRealm.add(folder, update: .modified)
            }
        }
    }

    func changePostFolderTitle(
        input: StoragePost,
        newFolderName: String
    ) {
        let url = input.url
        guard let object = localRealm.objects(RealmStoragePost.self).filter("url == %@", url as Any).first else {
            return
        }
        if object.folderName != newFolderName {
            do {
                try localRealm.write {
                    object.folderName = newFolderName
                }
                let updatedObject = localRealm.objects(RealmStoragePost.self).filter("url == %@", url as Any).first
                print(updatedObject as Any)
            } catch {
                print("Failed to update object: \(error)")
            }
        }
    }
    
    func changeFolderNameInStorage(
        input: [StoragePost],
        oldFolderName: String,
        newFolderName: String
    ) {
        // MARK: - folder
        guard let folderObject = localRealm.objects(ScrapStorageDTO.self).filter("folderName == %@", oldFolderName).first else {
            return
        }
        do {
            try localRealm.write {
                folderObject.folderName = newFolderName
            }
        } catch {
            print("폴더 이름 변경 에러")
        }
        
        // MARK: - posts
        let urls = input.map { $0.url }
        let objects = urls.map { localRealm.objects(RealmStoragePost.self).filter("url == %@", $0 as Any).first }
        for object in objects {
            do {
                try localRealm.write {
                    object?.folderName = newFolderName
                }
            } catch {
                print("Failed to update object: \(error)")
            }
        }
    }
    
    func getPosts() -> Results<RealmStoragePost> {
        let savedPosts = localRealm.objects(RealmStoragePost.self)
        return savedPosts
    }
    
    func getFolders() -> Results<ScrapStorageDTO> {
        let folders = localRealm.objects(ScrapStorageDTO.self)
        return folders
    }
    
    func getFolderImage(
        folderName: String
    ) -> String {
        let posts = localRealm.objects(RealmStoragePost.self).filter("folderName == %@", folderName)
        let postsImage = self.convertToStoragePost(input: posts)
        for post in postsImage {
            if post.img != "" {
                return post.img ?? ""
            }
        }
        return ""
    }
    
    func getFolderPosts(
        folderName: String
    ) -> Results<RealmStoragePost> {
        if folderName == "모든 게시글" {
            let allPosts = localRealm.objects(RealmStoragePost.self)
            return allPosts
        }
        let folderPosts = localRealm.objects(RealmStoragePost.self).filter("folderName == %@", folderName)
        return folderPosts
    }
    
    func getFolderPostsCount(
        folderName: String
    ) -> Int {
        if folderName == "모든 게시글" {
            let allPosts = localRealm.objects(RealmStoragePost.self)
            return allPosts.count
        }
        let posts = localRealm.objects(RealmStoragePost.self).filter("folderName == %@", folderName)
        return posts.count
    }
    
    func deletePost(
        url: String
    ) {
        guard let postToDelete = localRealm.objects(RealmStoragePost.self).filter("url == %@", url).first else { return }
        try! localRealm.write {
            localRealm.delete(postToDelete)
        }
    }

    func deleteFolder(
        folderName: String
    ) {
        do {
            try localRealm.write {
                if let folderToDelete = localRealm.objects(ScrapStorageDTO.self).filter("folderName == %@", folderName).first {
                    localRealm.delete(folderToDelete)
                }

                let postsInFolderToDelete = localRealm.objects(RealmStoragePost.self).filter("folderName == %@", folderName)
                localRealm.delete(postsInFolderToDelete)
            }
        } catch {
            print("Failed to delete folder: \(error)")
        }
    }
    
    func checkUniquePost(
        input: StoragePost
    ) -> Bool {
        let posts = convertToStoragePost(input: getPosts())
        for item in posts {
            if input == item {
                return false
            }
        }
        return true
    }
    
    func checkUniqueFolder(
        input: StorageDTO
    ) -> Bool {
        let folders = Set(convertToStorageDTO(input: getFolders()).map { $0.folderName })
        if folders.contains(input.folderName) {
            return false
        }
        return true
    }
    
    func checkUniqueFolderName(
        newFolderName: String
    ) -> Bool {
        let folders = Set(convertToStorageDTO(input: getFolders()).map { $0.folderName })
        if folders.contains(newFolderName) {
            return false
        }
        return true
    }
    
    func convertToStoragePost(
        input: Results<RealmStoragePost>
    ) -> [StoragePost] {
        var storagePosts = [StoragePost]()
        let inputSize = input.count
        for index in 0 ..< inputSize {
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
    
    func convertToStorageDTO(
        input: Results<ScrapStorageDTO>
    ) -> [StorageDTO] {
        var folderLists = [StorageDTO]()
        let inputSize = input.count
        for index in 0 ..< inputSize {
            let folder = StorageDTO(
                articleID: input[index].articleID,
                folderName: input[index].folderName,
                count: input[index].count
            )
            folderLists.append(folder)
        }
        return folderLists
    }
    
    func reversePosts(
        input: [StoragePost]
    ) -> [StoragePost] {
        let posts = Array(input.reversed())
        return posts
    }
    
    func deleteAllRealmData() {
        try! localRealm.write {
            localRealm.deleteAll()
        }
    }

    init() {
        print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find location.")
    }
}
