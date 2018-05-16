//
//  PostService.swift
//  CoreDataMulti
//
//  Created by Bondar Yaroslav on 29/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

enum Result <T> {
    case success(T)
    case error(Error)
}

final class PostService {
    
    static let shared = PostService()
    
    func getAll(success: @escaping ([Post]) -> Void, failed: @escaping (Error) -> Void) {
        let url = URL(string: URLs.posts)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failed(error)
            }
            if let data = data, let posts = try? JSONDecoder().decode([Post].self, from: data) {
                success(posts)
            }
            }.resume()
    }
}


enum URLs {
    static let base = "http://jsonplaceholder.typicode.com"
    static let posts = base + "/posts"
}

struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

import CoreData
extension Post {
    func postDB(for context: NSManagedObjectContext) -> PostDB {
        let post = PostDB(context: context)
        post.id = Int64(id)
        post.userId = Int64(userId)
        post.title = title
        post.body = body
        return post
    }
}
