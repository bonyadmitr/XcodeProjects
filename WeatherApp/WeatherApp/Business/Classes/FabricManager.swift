//
//  FabricManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 19/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Fabric
import Crashlytics
import UIKit

final class FabricManager: NSObject {
    
    var isEnabled = UserDefaultsManager.shared.isAnalyticsEnabled
    
    func startCrashlytics() {
        Crashlytics.sharedInstance().delegate = self
        Fabric.sharedSDK().debug = false
        Fabric.with([Crashlytics.self, Answers.self])
        
        logUser()
        logForCrash()
        setKeysForCrash()
    }
    
    func logCustomEvent(withName eventName: String, customAttributes customAttributesOrNil: [String : Any]? = nil) {
        if !isEnabled { return }
        Answers.logCustomEvent(withName: eventName, customAttributes: customAttributesOrNil)
    }
    
    /// logging that will be sent with your crash data
    /// will not show up in the system.log
    func logForCrash() {
        if !isEnabled { return }
        CLSLogv("Log awesomeness 10 %d %d %@", getVaList([1, 2, "three"]))
        CLSLogv("qqqq", "wwww", "eeeee")
    }
    
    func logUser() {
        if !isEnabled { return }
        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }
    
    func setKeysForCrash() {
        if !isEnabled { return }
        Crashlytics.sharedInstance().setIntValue(42, forKey: "MeaningOfLife")
        Crashlytics.sharedInstance().setObjectValue("Test value", forKey: "last_UI_action")
    }
    
    
    func log(searchText: String?) {
        if !isEnabled { return }
        guard let text = searchText, text.notEmpty else { return }
        Answers.logSearch(withQuery: text, customAttributes: [:])
    }
    
    func logSettings() {
        logCustomEvent(withName: "press settings")
    }
    
    func log(fontName: String) {
        logCustomEvent(withName: "selected font", customAttributes: ["fontName": fontName])
    }
    
    func log(color: UIColor) {
        logCustomEvent(withName: "selected color", customAttributes: ["color": String(describing: color)])
    }
    
    func log(cityName: String) {
        logCustomEvent(withName: "selected city", customAttributes: ["city": cityName])
    }
    
    func log(language: String) {
        logCustomEvent(withName: "selected language", customAttributes: ["language": language])
    }
    
    func log(appIcon: AppIcon) {
        logCustomEvent(withName: "selected app icon", customAttributes: ["icon": appIcon.name ?? "main"])
    }
}
extension FabricManager: CrashlyticsDelegate {
    func crashlyticsDidDetectReport(forLastExecution report: CLSReport, completionHandler: @escaping (Bool) -> Void) {
        print("report: ", report)
        completionHandler(true)
    }
}
extension FabricManager {
    @nonobjc static let shared = FabricManager()
}

private func CLSLogv(_ strings: String...) {
    // need to test
    let res = String(repeating: "%@ ", count: strings.count)
//    var res = ""
//    for _ in 0..<strings.count {
//        res += "%@ "
//    }
    CLSLogv(res, getVaList(strings))
}
