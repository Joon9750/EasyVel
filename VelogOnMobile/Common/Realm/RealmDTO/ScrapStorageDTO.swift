//
//  ScrapStorageDTO.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import Foundation

import Realm
import RealmSwift

final class ScrapStorageDTO: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var articleID: Int = 0
//    @Persisted var imgs: [String]?
    @Persisted var folderName: String?
    @Persisted var count: Int?
    
    override static func primaryKey() -> String? {
      return "RealmStoragePost"
    }
    
    convenience init(input: StorageDTO){
        self.init()
        
//        self.imgs = input.imgs
        self.articleID = input.articleID
        self.folderName = input.folderName
        self.count = input.count
    }
}
