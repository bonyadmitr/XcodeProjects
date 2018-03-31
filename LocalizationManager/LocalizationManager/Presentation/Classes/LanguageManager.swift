//
//  LanguageManager.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 2/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class LanguageManager {
    
    /// singleton
    static let shared = LanguageManager()
    
    /// array of available languages
    public var availableLanguages: [String] {
        return ["en", "he", "ru"]
        /// get from AppleLanguages
        //return UserDefaults.standard.array(forKey: "AppleLanguages") as! [String]
        //var availableLanguages = Bundle.main.localizations
        //if let indexOfBase = availableLanguages.index(of: "Base") {
        //    availableLanguages.remove(at: indexOfBase)
        //}
        //return availableLanguages
    }
    
    /// first language from Bundle.main.preferredLocalizations
    //public var defaultLanguage: String {
    //    guard let preferredLanguage = Bundle.main.preferredLocalizations.first,
    //        availableLanguages.contains(preferredLanguage)
    //        else { return devLanguage }
    //    return preferredLanguage
    //}
    
    /// Full localized language name
    public func displayName(for language: String) -> String? {
        let locale = NSLocale(localeIdentifier: LocalizationManager.shared.currentLanguage)
        return locale.displayName(forKey: NSLocale.Key.identifier, value: language)?.capitalized ?? nil
    }
}
