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
        let vc = UIAlertController(title: L10n.doYouLikeApp, message: L10n.rateUsShareIt, preferredStyle: .alert)
        vc.addAction(.init(title: L10n.rateNow, style: .default) { [weak self] _ in
            RateAppManager.googleApp.rateInAppOrRedirectToStore()
            self?.rateCounter.isDisabled = true
        })
        vc.addAction(.init(title: L10n.remindMeLater, style: .default) { [weak self] _ in
            self?.rateCounter.remindMeLater(for: 7)
        })
        vc.addAction(.init(title: L10n.dontShowItAgain, style: .destructive) { [weak self] _ in
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
    let itunesAppUrlPath: String
    
    /// appId should look like "idXXXXXXXXXX"
    init(appId: String) {
        self.appId = appId
        itunesAppUrlPath = "https://itunes.apple.com/app/\(appId)"
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
        openURL(string: itunesAppUrlPath, completion: completion)
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
    
    func shareApp(in controller: UIViewController) {
        guard let link = URL(string: itunesAppUrlPath) else {
            assertionFailure()
            return
        }
        let objectsToShare: [Any] = ["Settings by Yaroslav Bondar", link, Images.icSettings]
        
        /// taking long time to present
        /// https://stackoverflow.com/questions/13907156/uiactivityviewcontroller-taking-long-time-to-present
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        /// need access to gallery. NSPhotoLibraryUsageDescription key
        activityVC.excludedActivityTypes = [.saveToCameraRoll]
        
        activityVC.completionWithItemsHandler = { activityType, completed, array, error in
            
            guard completed else {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("user cancel")
                }
                return
            }
            
            /// should not be nil in any cases
            guard let activityType = activityType else {
                assertionFailure()
                return
            }
//            if activityType == .mail {
//            }
//            if activityType.rawValue == "com.apple.mobilenotes.SharingExtension" {
//            }
            print(activityType.rawValue)
        }
        
        /// for iPad
        //activityVC.popoverPresentationController?.sourceRect = controller.view.frame
        activityVC.popoverPresentationController?.sourceView = controller.view
        activityVC.popoverPresentationController?.permittedArrowDirections = []
        
        controller.present(activityVC, animated: true, completion: nil)
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
