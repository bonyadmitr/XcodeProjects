//
//  ActivityIndicatorCounter.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ActivityIndicatorCounter {
    
    private var startNumber = 0
    private var isStarted = false
    private let lock = NSLock()
    private weak var controller: ActivityIndicatorCounterController?
    
    init(controller: ActivityIndicatorCounterController) {
        self.controller = controller
    }
    
    func start() {
        lock.lock()
        defer { lock.unlock() }
        
        startNumber += 1
        if !isStarted {
            isStarted = true
            controller?.showIndicator()
        }
    }
    
    func stop() {
        lock.lock()
        defer { lock.unlock() }
        
        /// if more then 0
        if startNumber > 0 {
            startNumber -= 1
        }
        /// if became 0
        if startNumber == 0 {
            isStarted = false
            controller?.hideIndicator()
        }
    }
}
