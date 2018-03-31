//
//  VKAuthorizeResult.swift
//  VKSwiftyTest
//
//  Created by Bondar Yaroslav on 05/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

struct VKAuthorizeResult {
    
    private static let keyUserId = "VKAuthorizeResultIserId"
    static var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: keyUserId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyUserId)
        }
    }
    
    let expiresIn: String
    let userId: String
    let accessToken: String
    
    init?(json: [String: String]) {
        guard
            let expiresIn = json["expires_in"],
            let userId = json["user_id"],
            let accessToken = json["access_token"]
            else { return nil }
        self.expiresIn = expiresIn
        self.userId = userId
        self.accessToken = accessToken
    }
}
