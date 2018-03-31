//
//  PostRealm.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class PostRealm: MappableRealmObject {
    
    static let url = "http://jsonplaceholder.typicode.com/posts"
    static let provider = RealmProvider<PostRealm>()
    static let router = DefaultRouter<PostRealm>(baseUrl: url)
    
    var id = RealmOptional<Int>()
    var userId = RealmOptional<Int>()
    dynamic var title: String?
    dynamic var body: String?
    
    convenience init(id: Int) {
        self.init()
        self.id.value = id
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override func mapping(map: Map) {
        id.value <- map["id"]
        userId.value <- map["userId"]
        title <- map["title"]
        body <- map["body"]
    }
}
