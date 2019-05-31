//
//  TimerWrapper.swift
//  Timer
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/**
 DispatchSourceTimer
 https://medium.com/@vladislavzhukov/swift-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0%D0%B5%D0%BC-%D1%81-dispatchsourcetimer-dc4e0875ba2
 https://medium.com/over-engineering/a-background-repeating-timer-in-swift-412cecfd2ef9
 https://www.cocoawithlove.com/blog/2016/07/30/timer-problems.html
 https://developer.apple.com/documentation/dispatch/dispatchsourcetimer/2920395-schedule
 
 Timer
 https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/MinimizeTimerUse.html
 https://medium.com/@danielemargutti/the-secret-world-of-nstimer-708f508c9eb
*/

typealias StepHandler = () -> Void
typealias VoidHandler = () -> Void

/// can be used https://github.com/radex/SwiftyTimer

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
