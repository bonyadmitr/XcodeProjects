//
//  Post.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias Post = PostImp

final class PostImp: Codable, Promisable {
    var title: String
    var id: Int
    var userId: Int
    var body: String
    
    public init(title: String, id: Int, userId: Int, body: String) {
        self.title = title
        self.id = id
        self.userId = userId
        self.body = body
    }
    
    var storageValue: PostDB {
        let sv = PostDB()
        sv.title = title
        sv.id = id
        sv.userId = userId
        sv.body = body
        return sv
    }
    
//    enum CodingKeys: String, CodingKey {
//        case id = "employeeId"
//        case name
//        case favoriteToy
//    }
}
//extension Employee: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(id, forKey: .id)
//        try container.encode(favoriteToy.name, forKey: .gift)
//    }
//}

//extension Employee: Decodable {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decode(String.self, forKey: .name)
//        id = try values.decode(Int.self, forKey: .id)
//        let gift = try values.decode(String.self, forKey: .gift)
//        favoriteToy = Toy(name: gift)
//    }
//}

extension PostImp: Equatable {
    static func == (lhs: PostImp, rhs: PostImp) -> Bool {
        return lhs.id == rhs.id
    }
}
extension PostImp { //NSCopying
    func copy() -> PostImp {
        return PostImp(title: title, id: id, userId: userId, body: body)
    }
}

import Realm
import RealmSwift

typealias PostDB = PostRealm

final class PostRealm: BaseRealmObject {
    @objc dynamic var title: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var body: String = ""
    
    var simpleValue: Post {
        return Post(title: title, id: id, userId: userId, body: body)
    }
    
//    init(post: Post) {
//
//    }
    
//    public init(title: String, id: Int, userId: Int, body: String) {
//        self.title = title
//        self.id = id
//        self.userId = userId
//        self.body = body
//    }
    
    //    enum CodingKeys: String, CodingKey {
    //        case id = "employeeId"
    //        case name
    //        case favoriteToy
    //    }
}
