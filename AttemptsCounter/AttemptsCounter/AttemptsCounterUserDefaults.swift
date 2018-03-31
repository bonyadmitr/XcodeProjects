//
//  AttemptsCounterUserDefaults.swift
//  AttemptsCounter
//
//  Created by Bondar Yaroslav on 3/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class AttemptsCounterUserDefaults: AttemptsCounter {
    
    private let userDefaultsKey: String
    var attempts: Int {
        get { return UserDefaults.standard.integer(forKey: userDefaultsKey) }
        set { UserDefaults.standard.set(newValue, forKey: userDefaultsKey) }
    }
    
    let limit: Int
    let limitHandler: VoidHandler
    
    init(limit: Int,
         userDefaultsKey: String,
         limitHandler: @escaping VoidHandler)
    {
        self.userDefaultsKey = userDefaultsKey
        self.limit = limit
        self.limitHandler = limitHandler
    }
}

/// old one with private properties
//final class SavingAttemptsCounter {
//    
//    private let userDefaultsKey: String
//    private var attempts: Int {
//        get { return UserDefaults.standard.integer(forKey: userDefaultsKey) }
//        set { UserDefaults.standard.set(newValue, forKey: userDefaultsKey) }
//    }
//    
//    private let limit: Int
//    private let limitHandler: VoidHandler
//    
//    init(limit: Int,
//         userDefaultsKey: String,
//         limitHandler: @escaping VoidHandler)
//    {
//        self.userDefaultsKey = userDefaultsKey
//        self.limit = limit
//        self.limitHandler = limitHandler
//    }
//    
//    @discardableResult
//    func up() -> Bool {
//        attempts += 1
//        if attempts >= limit {
//            reset()
//            limitHandler()
//            return false
//        }
//        return true
//    }
//    
//    func reset() {
//        attempts = 0
//    }
//}

