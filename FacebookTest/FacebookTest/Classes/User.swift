//
//  User.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import FacebookCore
import SwiftyJSON

struct User: GraphResponseProtocol {
    
    var id: String?
    var name: String?
    var email: String?
    var pictureUrl: String?
    
    init(rawResponse: Any?) {
        guard let response = rawResponse as? [String: Any] else {
            return
        }
        let json = JSON(response)
        id = json["id"].string
        name = json["name"].string
        email = json["email"].string
        pictureUrl = json["picture"]["data"]["url"].string
    }
}

struct MyProfileRequest: GraphRequestProtocol {
    typealias Response = User
    var graphPath = FacebookUrls.me
    var parameters: [String: Any]? = ["fields": "name, email, picture.type(large)"]
    // ["fields": "name, first_name, last_name, email, friends, birthday, cover, devices, picture.type(large)"]
    
    //        var accessToken = AccessToken.current
    //        var httpMethod: GraphRequestHTTPMethod = .GET
    //        var apiVersion: GraphAPIVersion = .defaultVersion
}
