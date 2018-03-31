//
//  AuthorizationAdapter.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Alamofire

struct AuthorizationAdapter: RequestAdapter {
    
    static let shared = AuthorizationAdapter()
    
    var accessToken: String?
    
    init(accessToken: String? = AuthorizationToken.token) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var urlRequest = urlRequest
        
        if let token = accessToken {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

struct FlicrAdapter: RequestAdapter {
    
    static let shared = AuthorizationAdapter()
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var urlRequest = urlRequest
        
        if let token = AuthorizationToken.token {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
