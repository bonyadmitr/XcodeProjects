//
//  AuthorizationToken.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Foundation

struct AuthorizationToken: Token {
    
    static let key = "token"
    
    static var token: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: key) else {
                return nil
            }
            return token
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
