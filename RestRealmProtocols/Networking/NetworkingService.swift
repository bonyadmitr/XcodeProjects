//
//  NetworkingService.swift
//  Networking
//
//  Created by Bondar Yaroslav on 10.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Alamofire

struct URLs {
    private init() {}
    static let base = "http://jsonplaceholder.typicode.com"
    static let posts = base + "/posts"
}

class NetworkingService {
    
    static let instance = NetworkingService()
    
    func getAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        request(URLs.posts).responseJSON { responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                guard let posts = Post.getArray(from: value) else {
                    let error = NSError(domain: "ERROR with parsing array of posts", code: 1, userInfo: nil)
                    return completion(nil, error)
                }
                completion(posts, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getAllPosts(onSuccess: @escaping ([Post])->(), onError: ((Error)->())? ) {
        request(URLs.posts).responseJSON { responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                guard let posts = Post.getArray(from: value) else {
                    let error = NSError(domain: "ERROR with parsing array of posts", code: 1, userInfo: nil)
                    if let onError = onError {
                        onError(error)
                    }
                    return
                }
                onSuccess(posts)
                
            case .failure(let error):
                if let onError = onError {
                    onError(error)
                }
            }
        }
    }
}


