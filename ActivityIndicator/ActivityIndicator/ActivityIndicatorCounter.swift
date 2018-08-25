//
//  ActivityIndicatorCounter.swift
//  ActivityIndicator
//
//  Created by Bondar Yaroslav on 3/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol ActivityIndicatorCounterDelegate: class {
    func activityIndicatorCounterStarted()
    func activityIndicatorCounterStoped()
}

extension ActivityIndicatorCounterDelegate where Self: UIBlockable {
    func activityIndicatorCounterStarted() {
        showIndicator()
    }
    func activityIndicatorCounterStoped() {
        hideIndicator()
    }
}

final class ActivityIndicatorCounter {
    
    private var startNumber = 0
    private var isStarted = false
    private let lock = NSLock()
    private weak var delegate: ActivityIndicatorCounterDelegate?
    
    init(delegate: ActivityIndicatorCounterDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        lock.lock()
        defer { lock.unlock() }
        
        startNumber += 1
        if !isStarted {
            isStarted = true
            delegate?.activityIndicatorCounterStarted()
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
            delegate?.activityIndicatorCounterStoped()
        }
    }
}
