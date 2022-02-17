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
    let appStoreId: String
}

// TODO: in memory cache, on disk cache for last run, check only when screen opened https://developer.apple.com/documentation/uikit/uiapplication/1622952-canopenurl
// TODO: check real limit
/// possible error:  -canOpenURL: failed for URL: "youtube://" - error: "This app is not allowed to query for scheme youtube"
/// solution: add to Info.plist
//<key>LSApplicationQueriesSchemes</key>
//<array>
//    <string>youtube</string>
//</array>
///
/// possible error:  -canOpenURL: failed for URL: "unavailableApp://" - error: "The operation couldn’t be completed. (OSStatus error -10814.)"
/// means there is no such app
final class DeveloperAppsManager {
    
    static let shared = DeveloperAppsManager()
    
    /// open developer page in AppStore
    /// devId should look like "idXXXXXXXXXX"
    func openDeveloperAppStorePage(devId: String, completion: BoolHandler? = nil) {
        let urlPath = "https://itunes.apple.com/us/developer/\(devId)"
        do {
            try UIApplication.shared.open(scheme: urlPath)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    private let allApps: [SchemeApp] = [SchemeApp(name: "Test app",
                                                  scheme: "com.ios://",
                                                  appStoreId: "id544007664"),
                                        SchemeApp(name: "Some app",
                                                  scheme: "unavailableApp://",
                                                  appStoreId: "id284815942"),
                                        SchemeApp(name: "Google translate",
                                                  scheme: "googletranslate://",
                                                  appStoreId: "id414706506"),
                                        SchemeApp(name: "YouTube",
                                                  scheme: "youtube://",
                                                  appStoreId: "id544007664")]
    
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
