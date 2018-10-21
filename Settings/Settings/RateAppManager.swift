//
//  RateAppManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import StoreKit

typealias BoolHandler = (Bool) -> Void

final class RateAppManager {
    
    private let appId: String
    
    /// appId should look like "idXXXXXXXXXX"
    init(appId: String) {
        self.appId = appId
    }
    
    /// open developer page in AppStore
    /// devId should look like "idXXXXXXXXXX"
    /// appId doesn't need, can be refactored with openURL func
    func openDeveloperAppStorePage(devId: String, completion: BoolHandler? = nil) {
        let urlPath = "https://itunes.apple.com/us/developer/\(devId)"
        openURL(string: urlPath, completion: completion)
    }
    
    func rateInAppOrRedirectToStore() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            rateAppByRedirectToStore()
        }
    }
    
    /// open app page in AppStore
    func openAppStorePage(completion: BoolHandler? = nil) {
        let urlPath = "https://itunes.apple.com/app/\(appId)"
        openURL(string: urlPath, completion: completion)
    }
    
    /// open app review page in AppStore
    /// https://stackoverflow.com/questions/27755069/how-can-i-add-a-link-for-a-rate-button-with-swift
    /// "mt=8&" can be added after "?"
    func rateAppByRedirectToStore(completion: BoolHandler? = nil) {
        /// will be trigered in simulator by safary.
        /// from apple example code.
        let urlPath = "https://itunes.apple.com/app/\(appId)?action=write-review"
        
        /// will not be trigered in simulator
        //let urlPath = "itms-apps://itunes.apple.com/app/\(appId)?action=write-review"
        
        openURL(string: urlPath, completion: completion)
    }
    
    private func openURL(string: String, completion: BoolHandler?) {
        guard let url = URL(string: string) else {
            completion?(false)
            assertionFailure()
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            completion?(UIApplication.shared.openURL(url))
        }
    }
}

extension RateAppManager {
    /// google appId for example
    static let googleApp = RateAppManager(appId: "id284815942")
}

final class RateCounter {
    
    private enum UserDefaultsKeys {
        static let launchesCount = "RateCounter.launchesLimit"
        static let firstUseTimeInterval = "RateCounter.firstUseTimeInterval"
        static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
    }
    
    private let daysLimit: Int
    private let launchesLimit: Int
    private let eventsLimit: Int
    
    private var launchesCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchesCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.launchesCount)
        }
    }
    
    private var eventsCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchesCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.launchesCount)
        }
    }
    
//    private var daysCount: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchesCount)
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.launchesCount)
//        }
//    }
    
    private var canBeTriggered = true
    
    /// pass 0 to skip check
    init(untilPromptDays days: Int, launches: Int, significantEvents: Int) {
        daysLimit = days
        launchesLimit = launches
        eventsLimit = significantEvents
        
        canBeTriggered = isNewVersion
        
        
        
    }
    
    private var firstUseTimeInterval: TimeInterval {
        if let firstUseTimeInterval = UserDefaults.standard.object(forKey: UserDefaultsKeys.firstUseTimeInterval) as? Double {
            return firstUseTimeInterval
        } else {
            let firstUseTimeInterval = Date().timeIntervalSince1970
            UserDefaults.standard.set(firstUseTimeInterval, forKey: UserDefaultsKeys.firstUseTimeInterval)
            return firstUseTimeInterval
        }
    }
    
    private lazy var daysLimitTimeInterval: TimeInterval = firstUseTimeInterval + TimeInterval(daysLimit * 3600 * 24)
    
    func appLaunched() {
        launchesCount += 1
//        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchesCount) + 1
//        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.launchesCount)
        
    }
    
    /// triggered in init only
    private var isNewVersion: Bool {
        // Get the current bundle version for the app
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else { assertionFailure("Expected to find a bundle version in the info dictionary")
            return true
        }
        
        guard let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey) else {
            /// first launch
            UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
            return true
        }
        
        if currentVersion != lastVersionPromptedForReview {
            UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
            /// reset launchesCount for new version
            //launchesCount = 0
            return true
        }
        
        return false
    }
    
    func incrementUseCount() {
        
    }
    
    /// HaveBeenMet
    func areConditionsFulfilled() -> Bool {
        
        guard canBeTriggered else {
            return false
        }
        
        /// this check can be added to appLaunched func
        if launchesCount < launchesLimit {
            return false
        }
        
        if eventsCount < eventsLimit {
            return false
        }
        
        if Date().timeIntervalSince1970 < daysLimitTimeInterval {
            return false
        }

        return true
    }
}
