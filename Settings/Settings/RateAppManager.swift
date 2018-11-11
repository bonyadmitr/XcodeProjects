//
//  RateAppManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 10/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import StoreKit

typealias BoolHandler = (Bool) -> Void

final class RateAppDisplayManager {
    
    let rateCounter: RateCounter
    
    init(untilPromptDays days: Int, launches: Int, significantEvents: Int, foregroundAppears: Int) {
        rateCounter = RateCounter(untilPromptDays: days,
                                  launches: launches,
                                  significantEvents: significantEvents,
                                  foregroundAppears: foregroundAppears)
    }
    
    private weak var controller: UIViewController?
    
    
    var isDebug: Bool {
        get {
            return rateCounter.isDebug
        }
        set {
            rateCounter.isDebug = newValue
            
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.rateCounter.conditionsAreFulfilled()
                }
            }
        }
    }
    
    func startObserving(presentIn controller: UIViewController?) {
        self.controller = controller
        rateCounter.delegate = self
    }
    
    func presentAlert() {
        let vc = UIAlertController(title: "Do you like the app?", message: "Rate us, please, to share it with others!", preferredStyle: .alert)
        vc.addAction(.init(title: "Rate now", style: .default) { [weak self] _ in
            RateAppManager.googleApp.rateInAppOrRedirectToStore()
            self?.rateCounter.isDisabled = true
        })
        vc.addAction(.init(title: "Remind me later", style: .default) { [weak self] _ in
            self?.rateCounter.remindMeLater(for: 7)
        })
        vc.addAction(.init(title: "Don't show it again", style: .destructive)  { [weak self] _ in
            self?.rateCounter.isDisabled = true
        })
        controller?.present(vc, animated: true, completion: nil)
    }
}

extension RateAppDisplayManager: RateCounterDelegate {
    func rateCounterConditionsFulfilled() {
        presentAlert()
    }
}

final class RateAppManager {
    
    private let appId: String
    
    /// appId should look like "idXXXXXXXXXX"
    init(appId: String) {
        self.appId = appId
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
