//
//  LoginModelController.swift
//  MVC
//
//  Created by Bondar Yaroslav on 16/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

class LoginModelController {
    
    let loginCredentials = LoginCredentials()
    
    func loginWith(email: String, password: String, handler: (Bool) -> Void) {
        if email == "111" {
            loginCredentials.email = email
            loginCredentials.password = password
            handler(true)
        } else {
            handler(false)
        }
    }
}
