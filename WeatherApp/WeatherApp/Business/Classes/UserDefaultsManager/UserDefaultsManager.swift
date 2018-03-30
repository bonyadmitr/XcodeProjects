//
//  UserDefaultsManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 16/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    var userDefaults = UserDefaults.standard
    
    var place: Place {
        get {
            guard let data = userDefaults.object(forKey: DefaultKeys.place) as? Data,
                let place = NSKeyedUnarchiver.unarchiveObject(with: data) as? Place
            else {
                return Place(city: "Moscow", country: "Russia", full: NSAttributedString())
            }
            return place
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            userDefaults.set(data, forKey: DefaultKeys.place)
        }
    }
    
    var isAnalyticsEnabled: Bool {
        get { return userDefaults.bool(forKey: DefaultKeys.analyticsEnabled) }
        set { userDefaults.set(newValue, forKey: DefaultKeys.analyticsEnabled) }
    }
    
    func setAppVersion() {
        userDefaults.setValue(UIApplication.shared.version, forKey: DefaultKeys.appVersion)
    }
    
    func setAuthor() {
        userDefaults.setValue("Bondar Yaroslav", forKey: DefaultKeys.appAuthor)
    }
    
    func register(defaults registrationDictionary: [String : Any]) {
        userDefaults.register(defaults: registrationDictionary)
    }
}
