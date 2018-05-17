//
//  SavingInUserDefaultsAttemptsCounterForUniqueID.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

//final class SavingInUserDefaultsForUniqueIDAttemptsCounter {
//    
//    private let limit: Int
//    private let autoReset: Bool
//    private let uniqueID: String
//    private let userDefaultsForUniqueID: UserDefaultsForUniqueID
//    
//    private var attempts: Int {
//        didSet { userDefaultsForUniqueID.set(attempts, forKey: uniqueID) }
//    }
//    
//    init(limit: Int, uniqueID: String, autoReset: Bool = false) {
//        self.limit = limit
//        self.autoReset = autoReset
//        self.uniqueID = uniqueID
//        
//        userDefaultsForUniqueID = UserDefaultsForUniqueID(id: uniqueID)
//        attempts = userDefaultsForUniqueID.object(forKey: uniqueID) as? Int ?? 0
//    }
//}
//extension SavingInUserDefaultsForUniqueIDAttemptsCounter: AttemptsCounter {
//    @discardableResult
//    func up(limitHandler: @escaping VoidHandler) -> Bool {
//        attempts += 1
//        if attempts >= limit {
//            if autoReset {
//                reset()
//            }
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
