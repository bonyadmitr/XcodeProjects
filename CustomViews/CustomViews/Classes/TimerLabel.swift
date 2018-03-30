//
//  TimerLabel.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 3/14/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol TimerLabelDelegate: class {
    func timerLabelDidFinishRunning()
}

final class TimerLabel: UILabel {
    
    private var timer: Timer?
    private var timerLimit = 0
    private var timerStep = 0
    private var startDate: Date?
    
    weak var delegate: TimerLabelDelegate?
    var isDead = true
    
    func setupTimer(with timeInterval: Float = 1.0, timerLimit: Int) {
        guard isDead else {
            return
        }
        self.timerLimit = timerLimit
        timerStep = 0
        isDead = false
        stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        setupTimerLabel()
        startDate = Date()
        setupAppLifetimeObserver()
    }
    
    func dropTimer() {
        timerStep = timerLimit
    }
    
    private func setupAppLifetimeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func applicationWillEnterForeground() {
        guard let startDate = startDate else {
            return
        }
        
        let timeIntervalFromStartCurrentDate = Int(Date().timeIntervalSince(startDate))
        
        if timeIntervalFromStartCurrentDate > timerLimit {
            timerStep = timerLimit
        } else {
            timerStep = Int(timeIntervalFromStartCurrentDate)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateTimer() {
        timerStep += 1
        setupTimerLabel()
        checkLifeSpent()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkLifeSpent() {
        if timerStep >= timerLimit {
            isDead = true
            stopTimer()
            delegate?.timerLabelDidFinishRunning()
        }
    }
    
    private func setupTimerLabel() {
        var spendTime = timerLimit - timerStep
        if spendTime < 0 {
            spendTime = 0
        }
        let min = Int(spendTime) / 60
        let sec = Int(spendTime) % 60
        text = String(format:"%02i:%02i", min, sec)
    }
}
