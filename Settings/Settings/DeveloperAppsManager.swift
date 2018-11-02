//
//  DeveloperAppsManager.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

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
    
}
