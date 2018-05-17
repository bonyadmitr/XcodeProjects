//
//  AttemptsCounter.swift
//  OptIn
//
//  Created by Bondar Yaroslav on 5/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias VoidHandler = () -> Void

protocol AttemptsCounter {
    @discardableResult func up(limitHandler: @escaping VoidHandler) -> Bool
    func reset()
}
