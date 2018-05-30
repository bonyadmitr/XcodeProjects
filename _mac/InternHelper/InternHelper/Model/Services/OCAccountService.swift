//
//  OCAccountService.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 22.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import PromiseKit
import Cocoa


class OCAccountService {
    
    // MARK: - Properties
    static var currentUser: OCUser?
    static var credentials: OCUserCredentials?
    
    
    // MARK: - Repository
    static let repository = OCUserRepository(baseUrl: Constants.usersURL)
    
    
    // MARK: - Methods
    static func login() -> Promise<OCUser> {
        return repository.getMe().recover { error -> Promise<OCUser> in
            guard let credentials = credentials else {
                return Promise(error: ValidationError.EmptyCredentials)
            }
            return self.repository.login(credentials).then { (token) -> Promise<OCUser> in
                self.repository.token = token
                return self.repository.getMe()
            }
        }
    }
    
    static func register(user: OCUser) -> Promise<OCUser> {
        return repository.create(user)
    }
    
    static func logout() -> Promise<Void> {
        return repository.logout()
    }
    
//    static func requestNewCodeOrRegister() -> Promise<Void> {
//        guard let credentials = credentials else {
//            return Promise(error: ValidationError.EmptyCredentials)
//        }
//        
//        return repository.reset(credentials).recover { error -> Promise<Void> in
//            let user = OCUser()
//            user.phone = self.credentials!.phone
//            return self.repository.create(user).asVoid()
//        }
//    }
    
//    static func getVerificationCode()-> Promise<OCUserCredentials> {
//        return repository.getVerificationCode(credentials!)
//    }
    
    static func updateUser() -> Promise<OCUser> {
        return repository.update(currentUser!)
    }
    
    
    static func getAll() ->  Promise<[OCUser]> {
        return repository.findAll()
    }
}





