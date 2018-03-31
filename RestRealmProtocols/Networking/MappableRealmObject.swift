//
//  MappableRealmObject.swift
//  Networking
//
//  Created by Bondar Yaroslav on 11.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper

class MappableRealmObject: Object, Mappable {
    
    required init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    func mapping(map: Map) {}
}

//protocol Q {
//    associatedtype ModelS
//    typealias Model = Self
//    
//    static var url: String { get }
//    static var provider: DataBaseProvider { get }
//    static var router: RouterAll { get }
//}
