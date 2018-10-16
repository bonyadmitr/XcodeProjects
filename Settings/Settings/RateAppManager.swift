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
    
    init(appId: String) {
        self.appId = appId
    }
    
    /// open app page in AppStore
    func openAppStorePage(completion: BoolHandler?) {
        //let urlPath = "itms-apps://itunes.apple.com/ru/app/cosmeteria/\(appId)"
        let urlPath = "itms-apps://itunes.apple.com/app/\(appId)"
        openURL(string: urlPath, completion: completion)
    }
    
    /// open app review page in AppStore
    /// appId should look like "idXXXXXXXXXX"
    /// https://stackoverflow.com/questions/27755069/how-can-i-add-a-link-for-a-rate-button-with-swift
    /// "mt=8&" can be added after "?"
    func rateAppByRedirectToStore(completion: BoolHandler?) {
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
    static let shared = RateAppManager(appId: "id284815942")
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            /// google example
            rateAppByRedirectToStore(completion: nil)
        }
    }
}
