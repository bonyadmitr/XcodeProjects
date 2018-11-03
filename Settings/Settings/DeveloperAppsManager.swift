//
//  DeveloperAppsManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit


struct SchemeApp {
    let name: String
    let scheme: String
}

final class DeveloperAppsManager {
    
    static let shared = DeveloperAppsManager()
    
    /// open developer page in AppStore
    /// devId should look like "idXXXXXXXXXX"
    /// appId doesn't need, can be refactored with openURL func
    func openDeveloperAppStorePage(devId: String, completion: BoolHandler? = nil) {
        let urlPath = "https://itunes.apple.com/us/developer/\(devId)"
        do {
            try UIApplication.shared.open(scheme: urlPath)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    private let allApps: [SchemeApp] = [SchemeApp(name: "Test app", scheme: "com.ios://")]
    
    var apps: (availableApps: [SchemeApp], unavailableApps: [SchemeApp]) {
        var availableApps: [SchemeApp] = []
        var unavailableApps: [SchemeApp] = []
        
        for app in allApps {
            guard let url = URL(string: app.scheme) else {
                assertionFailure("app scheme: app.scheme is invalid")
                continue
            }
            
            if UIApplication.shared.canOpenURL(url) {
                availableApps.append(app)
            } else {
                unavailableApps.append(app)
            }
        }
        return (availableApps, unavailableApps)
    }
}
