//
//  RateCounter.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol RateCounterDelegate: class {
    func rateCounterConditionsFulfilled()
}

final class RateCounter {
    
    private enum Keys {
        static let launchesCount = "RateCounter.launchesLimit"
        static let foregroundAppearsCount = "RateCounter.foregroundAppearsCount"
        static let eventsCount = "RateCounter.eventsCount"
        static let firstUseTimeInterval = "RateCounter.firstUseTimeInterval"
        static let isDisabled = "RateCounter.isDisabled"
        static let remindMeLaterDays = "RateCounter.remindMeLaterDays"
    }
    
    private let daysLimit: Int
    private let launchesLimit: Int
    private let eventsLimit: Int
    private let foregroundAppearsLimit: Int
    
    private var token: NSObjectProtocol?
    
    private var launchesCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.launchesCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.launchesCount)
        }
    }
    
    private var foregroundAppearsCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.foregroundAppearsCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.foregroundAppearsCount)
        }
    }
    
    private var eventsCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.eventsCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.eventsCount)
        }
    }
    
    var isDisabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isDisabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isDisabled)
        }
    }
    
    private var remindMeLaterDays: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.remindMeLaterDays)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.remindMeLaterDays)
        }
    }
    
    private var firstUseTimeInterval: TimeInterval {
        if let firstUseTimeInterval = UserDefaults.standard.object(forKey: Keys.firstUseTimeInterval) as? Double {
            return firstUseTimeInterval
        } else {
            let firstUseTimeInterval = Date().timeIntervalSince1970
            UserDefaults.standard.set(firstUseTimeInterval, forKey: Keys.firstUseTimeInterval)
            return firstUseTimeInterval
        }
    }
    
    private lazy var daysLimitTimeInterval: TimeInterval = firstUseTimeInterval + timeInterval(from: daysLimit) + timeInterval(from: remindMeLaterDays)
    
    private func timeInterval(from days: Int) -> TimeInterval {
        return TimeInterval(days * 3600 * 24)
    }
    
    weak var delegate: RateCounterDelegate?
    
    /// pass 0 to skip check
    init(untilPromptDays days: Int, launches: Int, significantEvents: Int, foregroundAppears: Int) {
        daysLimit = days
        launchesLimit = launches
        eventsLimit = significantEvents
        foregroundAppearsLimit = foregroundAppears
        
        subscribeForegroundAppears()
        
        /// must be triggered first time
        _ = firstUseTimeInterval
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    private func subscribeForegroundAppears() {
        token = NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: .main) { [weak self] _ in
            self?.foregroundAppearsCount += 1
            self?.checkConditionsForFulfill()
        }
    }
    
    func appLaunched() {
        launchesCount += 1
        checkConditionsForFulfill()
    }
    
    func incrementEventsCount() {
        eventsCount += 1
        checkConditionsForFulfill()
    }
    
    /// HaveBeenMet
    func checkConditionsForFulfill() {
        
        if isDisabled {
            return
        }
        
        /// this check can be added to appLaunched func
        if launchesCount < launchesLimit {
            return
        }
        
        if eventsCount < eventsLimit {
            return
        }
        
        if Date().timeIntervalSince1970 < daysLimitTimeInterval {
            return
        }
        
        if foregroundAppearsCount < foregroundAppearsLimit {
            return
        }
        
        /// conditions are fulfilled
        delegate?.rateCounterConditionsFulfilled()
    }
    
    func resetLaunchesEventsAndForegroundAppears() {
        launchesCount = 0
        eventsCount = 0
        foregroundAppearsCount = 0
        isDisabled = false
    }
    
    func remindMeLater(for days: Int) {
        remindMeLaterDays += days
        daysLimitTimeInterval += timeInterval(from: days)
    }
}

/// triggered in init only
//    private var isNewVersion: Bool {
//        /// Get the current bundle version for the app
//        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else { assertionFailure("Expected to find a bundle version in the info dictionary")
//            return true
//        }
//
//        guard let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey) else {
//            /// first launch
//            UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
//            return true
//        }
//
//        if currentVersion != lastVersionPromptedForReview {
//
//            /// reset launchesCount for new version
//            //launchesCount = 0
//            return true
//        }
//
//        return false
//    }
//
//    func saveCurrentAppVersionAsNew() {
//        /// Get the current bundle version for the app
//        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else { assertionFailure("Expected to find a bundle version in the info dictionary")
//            return
//        }
//        UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
//    }
