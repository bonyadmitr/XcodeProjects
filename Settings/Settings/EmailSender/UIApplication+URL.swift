//
//  UIApplication+URL.swift
//  EmailSender
//
//  Created by Bondar Yaroslav on 06/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// UIApplication.shared
extension UIApplication {
    
    func open(url: URL) {
        if #available(iOS 10.0, *) {
            open(url, options: [:], completionHandler: nil)
        } else {
            openURL(url)
        }
    }
    
    func openIfCan(url: URL) {
        if canOpenURL(url) {
            open(url: url)
        }
    }
    
    func open(scheme: String) throws {
        guard let url = URL(string: scheme) else {
            assertionFailure()
            throw NSError(domain: "scheme: \(scheme) is invalid", code: NSFileReadUnsupportedSchemeError, userInfo: nil)
        }
        openIfCan(url: url)
    }
    
    /// "mailto:" will open Mail app with clear send window
    func openMailApp() {
        try? open(scheme: "message://")
    }
    
    /// call to any number, even on "something"
    func call(phoneNumber: String) {
        try? open(scheme: "tel://\(phoneNumber)")
    }
    
    /// will open app settings if they are exists
    /// can be not exist if there is no anything to set (you didn't get any privacy)
    func openSettings() {
        try? open(scheme: UIApplicationOpenSettingsURLString)
    }
}
