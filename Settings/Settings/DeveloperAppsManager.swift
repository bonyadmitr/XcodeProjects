//
//  DeveloperAppsManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias SchemeAppTuple = (installedApps: [SchemeApp], newApps: [SchemeApp])

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
    
    private let allApps: [SchemeApp] = [SchemeApp(name: "Test app", scheme: "com.ios://"),
                                        SchemeApp(name: "Some app", scheme: "unavailableApp://")]
    
    var apps: SchemeAppTuple {
        var installedApps: [SchemeApp] = []
        var newApps: [SchemeApp] = []
        
        for app in allApps {
            guard let url = URL(string: app.scheme) else {
                assertionFailure("app scheme: app.scheme is invalid")
                continue
            }
            
            if UIApplication.shared.canOpenURL(url) {
                installedApps.append(app)
            } else {
                newApps.append(app)
            }
        }
        return (installedApps, newApps)
    }
}
