//
//  ViewController.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let validator: ResponseValidator = { data, response in
//            print(response)
            
            let valid1 = (response.allHeaderFields["Content-Type"] as? String) == "application/json; charset=utf-8"
            let valid2 = (200 ..< 300) ~= response.statusCode 
            return valid1 && valid2
        }
        
//        URLSessionWrapper.request(
//            .get,
//            path: "https://jsonplaceholder.typicode.com/posts/1",
//            headers: nil,
//            parameters: nil,
//            validator: validator,
//            completion: { result in 
//                switch result {
//                case .success(let data):
//                    let res = String(data: data, encoding: .utf8)!
//                    print(res)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//        })
        
        
        URLSessionWrapper.request(
            .get,
            path: "https://jsonplaceholder.typicode.com/comments",
            headers: nil,
            parameters: ["postId": "1"],
            validator: validator,
            completion: { result in 
                switch result {
                case .success(let data):
                    let res = String(data: data, encoding: .utf8)!
                    print(res)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        })
        
    }
}

