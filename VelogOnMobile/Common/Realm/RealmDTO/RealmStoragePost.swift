//
//  RealmStoragePost.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/05.
//

import Foundation

import Realm
import RealmSwift

final class RealmStoragePost: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var img: String?
    @Persisted var name: String?
    @Persisted var summary: String?
    @Persisted var title: String?
    @Persisted var url: String?
    @Persisted var articleID: Int?
    
    override static func primaryKey() -> String? {
      return "RealmStoragePost"
    }
    
    convenience init(input: StoragePost, articleID: Int){
        self.init()
        
        self.img = input.img
        self.name = input.name
        self.summary = input.summary
        self.title = input.title
        self.url = input.url
        self.articleID = articleID
    }
}
