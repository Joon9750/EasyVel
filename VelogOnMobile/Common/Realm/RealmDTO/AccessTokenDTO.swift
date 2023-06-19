//
//  AccessTokenDTO.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/19.
//

import Foundation

import Realm
import RealmSwift

final class AccessTokenDTO: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var accessToken: String?
    
    override static func primaryKey() -> String? {
      return "RealmStoragePost"
    }
    
    convenience init(input: String){
        self.init()
        
        self.accessToken = input
    }
}
