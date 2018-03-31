//
//  TimerWrapper.swift
//  Timer
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation


typealias StepHandler = () -> Void
typealias VoidHandler = () -> Void

class TimerWrapper: NSObject {
    
    private var timer: Timer?
    private var stepHandler: StepHandler?
    
    @nonobjc
    func start(with timeInterval: Float, stepHandler: @escaping StepHandler) {
        start(with: TimeInterval(timeInterval), stepHandler: stepHandler)
    }
    
    func start(with timeInterval: TimeInterval, stepHandler: @escaping StepHandler) {
        self.stepHandler = stepHandler
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer() {
        stepHandler?()
    }
    
    deinit {
        stop()
    }
}
