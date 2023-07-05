//
//  AutoSignInDTP.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/18.
//

import Foundation

import Realm
import RealmSwift

final class AutoSignInDTO: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var didSignIn: Bool?
    
    override static func primaryKey() -> String? {
      return "RealmStoragePost"
    }
    
    convenience init(input: Bool){
        self.init()
        
        self.didSignIn = input
    }
}
