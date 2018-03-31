//
//  PostService.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation
import PromiseKit

protocol PostService: class {
    func getAll(handler: @escaping ([Post], Error?) -> Void)
}

final class PostServiceImp {
    let postClient: PostClient
    let postStorage: PostStorage
    
    init(postClient: PostClient, postStorage: PostStorage) {
        self.postClient = postClient
        self.postStorage = postStorage
    }
}

extension PostServiceImp: PostService {
    
    func getAll(handler: @escaping ([Post], Error?) -> Void) {
        _ = firstly {
            postStorage.getAll()
        }.then { postsDB -> Promise<[Post]> in
            let posts = postsDB.map { $0.simpleValue }
            handler(posts, nil)
            return self.postClient.all()
        }.then { posts in
            posts.promise
        }.then { posts -> Promise<[PostDB]> in
            handler(posts, nil)
            let postsDB = posts.map { $0.storageValue }
            return self.postStorage.save(postsDB)
        }.catch { error in
            handler([], error)
        }
    }
}
