//
//  AttemptsCounter.swift
//  AttemptsCounter
//
//  Created by Bondar Yaroslav on 3/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

public typealias VoidHandler = () -> Void

protocol AttemptsCounter {
    var attempts: Int { get set }
    var limit: Int { get }
    var limitHandler: VoidHandler { get }
    @discardableResult mutating func up() -> Bool
    mutating func reset()
}
extension AttemptsCounter {
    @discardableResult
    mutating func up() -> Bool {
        attempts += 1
        if attempts >= limit {
            reset()
            limitHandler()
            return false
        }
        return true
    }
    
    mutating func reset() {
        attempts = 0
    }
}
