//
//  CountdownTimer.swift
//  Timer
//
//  Created by Bondar Yaroslav on 14/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias CountdownStepHandler = (String) -> Void

final class CountdownTimer: NSObject {
    
    private let timer = TimerWrapper()
    private var timerLimit = 0
    private var timerLifetime = 0
    private var startDate: Date?
    
    var isDead = true
    
    private var stepHandler: CountdownStepHandler?
    private var completion: VoidHandler?
    
    func setup(timeInterval: Float,
               timerLimit: Int,
               stepHandler: CountdownStepHandler?,
               completion: VoidHandler?) {
        guard isDead else {
            return
        }
        
        self.timerLimit = timerLimit
        self.stepHandler = stepHandler
        self.completion = completion
        
        timerLifetime = 0
        isDead = false
        startDate = Date()
        setupAppLifetimeObserver()
        
        timer.start(with: timeInterval) { [weak self] in
            self?.updateTimer()
        }
        
        /// CHECK for first start
        stepHandler?(formattedCountdown)
    }
    
    /// end timer and send completion
    func drop() {
        timerLifetime = timerLimit
    }
    
    /// cannot be tested on simulator
    private func setupAppLifetimeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    @objc private func applicationWillEnterForeground() {
        guard let startDate = startDate else {
            return
        }
        
        let passedTime = Int(Date().timeIntervalSince(startDate))
        
        if passedTime > timerLimit {
            drop()
        } else {
            timerLifetime = Int(passedTime)
        }
    }
    
    deinit {
        stop()
        print("- deinit CountdownTimer")
    }
    
    func stop() {
        isDead = true
        timer.stop()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateTimer() {
        timerLifetime += 1
        stepHandler?(formattedCountdown)
        checkTimerEnd()
    }
    
    private func checkTimerEnd() {
        if timerLifetime >= timerLimit {
            isDead = true
            stop()
            completion?()
        }
    }
    
    private var formattedCountdown: String {
        var countdownTime = timerLimit - timerLifetime
        if countdownTime < 0 {
            countdownTime = 0
        }
        let minutes = countdownTime / 60
        let seconds = countdownTime % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
