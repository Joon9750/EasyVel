//
//  ScrapStorageDTO.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import Foundation

import Realm
import RealmSwift

struct FolderDTO {
    var imgs: [String]?
    var folderName: String?
    var count: Int?
}

final class ScrapFolderDTO: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var imgs: [String]?
    @Persisted var folderName: String?
    @Persisted var count: Int?
    
    override static func primaryKey() -> String? {
      return "RealmStoragePost"
    }
    
    convenience init(input: FolderDTO){
        self.init()
        
        self.imgs = input.imgs
        self.folderName = input.folderName
        self.count = input.count
    }
}

