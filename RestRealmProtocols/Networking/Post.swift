//
//  Post.swift
//  Networking
//
//  Created by Bondar Yaroslav on 29.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Foundation

struct Post {
    
    var id: Int
    var title: String
    var body: String
    var userId: Int
    
    init?(json: [String: Any]) {
        
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String,
            let userId = json["userId"] as? Int
        else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
    
    static func getArray(from jsonArray: Any) -> [Post]? {
        
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var posts: [Post] = []
        
        for jsonObject in jsonArray {
            if let post = Post(json: jsonObject) {
                posts.append(post)
            }
        }
        return posts
    }
}
