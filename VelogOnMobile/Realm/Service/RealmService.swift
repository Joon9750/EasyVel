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
    
    let localRealm = try! Realm()
    
    func addPost(item: StoragePost) {
        let post = RealmStoragePost(input: item)
        try! localRealm.write {
            localRealm.add(post)
        }
        print("add")
    }
    
    func getPosts() -> Results<RealmStoragePost> {
        print("get")
        let savedPosts = localRealm.objects(RealmStoragePost.self)
        return savedPosts
    }
    
    func deletePost(url: String) {
        try! localRealm.write{
            localRealm.delete(localRealm.objects(RealmStoragePost.self).filter("url == \(url)"))
        }
        print("deleted")
    }
    
    func readDB(){
        let subScriber = localRealm.objects(RealmStoragePost.self)
        print(subScriber)
    }
    
    func checkUniquePost(input: StoragePost) -> Bool {
        let posts = convertToStoragePost(input: self.getPosts())
        for item in posts {
            if input == item {
                return false
            }
        }
        return true
    }
    
    func convertToStoragePost(input: Results<RealmStoragePost>) -> [StoragePost] {
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
        
    // 스키마 수정시 한번 돌려야 한다.
    func resetDB(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
          realmURL,
          realmURL.appendingPathExtension("lock"),
          realmURL.appendingPathExtension("note"),
          realmURL.appendingPathExtension("management")
        ]

        for URL in realmURLs {
          do {
            try FileManager.default.removeItem(at: URL)
          } catch {
            // handle error
          }
        }
    }
    
    init() {
        print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find location.")
    }
}
