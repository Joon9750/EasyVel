//
//  CurrentSearchDTO.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/30.
//

import Foundation

import RealmSwift

final class CurrentSearchDTO: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var currentTag: String?
    
    override static func primaryKey() -> String? {
      return "CurrentSearchDTO"
    }
    
    convenience init(currentTag: String){
        self.init()
        
        self.currentTag = currentTag
    }
}
