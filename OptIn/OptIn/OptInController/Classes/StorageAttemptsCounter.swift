//
//  StorageAttemptsCounter.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class StorageAttemptsCounter {
    
    private let limit: Int
    private let autoReset: Bool
    private let anyStorage: AnyStorage
    private let storageAttemptsCounterKey = "storageAttemptsCounterKey"
    
    private var attempts: Int {
        didSet { anyStorage.set(attempts, forKey: storageAttemptsCounterKey) }
    }
    
    init(limit: Int, anyStorage: AnyStorage, autoReset: Bool = false) {
        self.limit = limit
        self.autoReset = autoReset
        self.anyStorage = anyStorage
        attempts = anyStorage.object(forKey: storageAttemptsCounterKey) as? Int ?? 0
    }
}
extension StorageAttemptsCounter: AttemptsCounter {
    @discardableResult
    func up(limitHandler: @escaping VoidHandler) -> Bool {
        attempts += 1
        if attempts >= limit {
            if autoReset {
                reset()
            }
            limitHandler()
            return false
        }
        return true
    }
    
    func reset() {
        attempts = 0
    }
}
