//
//  InMemoryAttemptsCounter.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class InMemoryAttemptsCounter {
    private var attempts: Int = 0
    private let limit: Int
    private let autoReset: Bool
    
    init(limit: Int, autoReset: Bool = false) {
        self.limit = limit
        self.autoReset = autoReset
    }
}
extension InMemoryAttemptsCounter: AttemptsCounter {
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
