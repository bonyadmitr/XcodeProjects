//
//  PostClient.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Alamofire
import PromiseKit

protocol PostClient {
    func all() -> Promise<[Post]>
    func one(id: Int) -> Promise<Post>
}

final class PostClientImp: PostClient, ClientGetAll, ClientGetOne {
    typealias Paths = PostUrls
    typealias Entity = Post
}
