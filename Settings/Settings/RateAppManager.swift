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
        static let processCompletedCountKey = "processCompletedCountKey"
        static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
    }
    
    private let daysLimit: Int
    private let launchesLimit: Int
    private let eventsLimit: Int
    
    init(untilPromptDays days: Int, launches: Int, significantEvents: Int) {
        daysLimit = days
        launchesLimit = launches
        eventsLimit = significantEvents
    }
    
    func appLaunched() {
        
    }
    
    func incrementUseCount() {
        
    }
    
    func q() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey) + 1
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)
        
        print("Process completed \(count) time(s)")
        
        // Get the current bundle version for the app
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }
        
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        
        // Has the process been completed several times and the user has not already been prompted for this version?
        if count >= 4 && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
//                if UIViewController() is ProcessCompletedViewController {
//                    SKStoreReviewController.requestReview()
                    UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
//                }
            }
        }

    }
}
