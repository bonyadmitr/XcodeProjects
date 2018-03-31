//
//  NetworkingProvider.swift
//  OrderAppCustomerMy
//
//  Created by Bondar Yaroslav on 28.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Alamofire

class NetworkingProvider {
    
    static let instance = NetworkingProvider()
    
    let baseUrl =  "http://localhost:3000/posts/1" //"http://jsonplaceholder.typicode.com"
    
    func response() {
        Alamofire.request(baseUrl + "/posts").response { response in
            print("\n-------------------------------------------------------------------\n")
            print(response)
        }
    }
    
//[String: Any]
    func responseJSON(completion: @escaping ([NSDictionary]?, Error?) -> Void ) {
        request(baseUrl + "/posts")
            .validate()
            .responseJSON { responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                guard let posts = value as? [NSDictionary] else { return }
                completion(posts, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func responseData() {
        request(baseUrl + "/posts").responseData { responseData in
            print("\n-------------------------------------------------------------------\n")
            print(responseData)
        }
    }
    
    func responseString() {
        request(baseUrl + "/posts").responseString { responseString in
            print("\n-------------------------------------------------------------------\n")
            print(responseString)
        }
    }
    
    func getArray(complitionHandler: (result: [String], error: Error) ) {
        request(baseUrl + "/posts").responseJSON { responseJSON in
            
//            let q = ["q"]
//            return complitionHandler(q, NSError(domain: "q", code: 1, userInfo: nil))
            
        }
    }
}
