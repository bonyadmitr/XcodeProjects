//
//  LoginViewDelegate.swift
//  MVC
//
//  Created by Bondar Yaroslav on 16/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol LoginViewDelegate: class {
    func didLogin(email: String, password: String)
}
