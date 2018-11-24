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
        
        
        let validator: ResponseValidator = { response in
//            print(response)
            
            let valid1 = (response.allHeaderFields["Content-Type"] as? String) == "application/json; charset=utf-8"
            let valid2 = (200 ..< 300) ~= response.statusCode 
            return valid1 && valid2
        }
        
//        URLSessionWrapper.shared.request(
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
        
        
        var date = Date()
        
//        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/dd/Big_%26_Small_Pumkins.JPG")!
//        let data = try! Data(contentsOf: url)
//        print("contentsOf data", data.count)
//        print("contentsOf date", -date.timeIntervalSinceNow)
        
        date = Date()
        URLSessionWrapper.shared.request(
//            "https://commons.wikimedia.org/wiki/File:Fronalpstock_big.jpg",
            "https://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_720p_surround.avi",
//            "https://jsonplaceholder.typicode.com/posts/1",
            method: .get,
//            parameters: ["postId": "1"],
//            validator: validator,
            percentageHandler: { percentage in
                print("percentage", percentage)
            },
            completion: { result in
                switch result {
                case .success(let data):
                    print("request data", data.count)
                    print("request date", -date.timeIntervalSinceNow)
                    print("success")
//                    let res = String(data: data, encoding: .utf8)!
//                    print(res)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        })
        print("async")
        
//        URLSessionWrapper.shared.request("https://ru.wikipedia.org/wiki/Сайт") { result in
//            switch result {
//            case .success(_):
//                //print(String(data: data, encoding: .utf8)!)
//                print("success russian characters in url")
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}

