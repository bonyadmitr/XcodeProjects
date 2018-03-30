//
//  LocalizationManager.swift
//  LocalizationInspectable
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// https://github.com/marmelroy/Localize-Swift

/// https://github.com/maximbilan/ios_language_manager
/// for it used: http://www.developersite.org/102-26935-ios

/// can be added notification for NotificationCenter when language changed
final class LocalizationManager {
    
    /// singleton
    static let shared = LocalizationManager()
    
    /// current language key for UserDefaults
    private let currentLanguageKey = "LMCurrentLanguageKey"
    
    /// key for AppleLanguages
    private let appleLanguageKey = "AppleLanguages"
    /// AppleLanguages wrapper
    private var appleLanguage: String? {
        get {
            return UserDefaults.standard.array(forKey: appleLanguageKey)?.first as? String
        }
        set {
            UserDefaults.standard.set([newValue], forKey: appleLanguageKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// development language. default is English. setup if it defferent
    public var devLanguage = "en"
    
    /// array of available languages ("en", "ru")
    public var availableLanguages: [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.index(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /// current language or default one
    public private(set) var currentLanguage: String {
        get {
            if let currentLanguage = UserDefaults.standard.object(forKey: currentLanguageKey) as? String {
                return currentLanguage
            }
            return defaultLanguage
        }
        set (language) {
            guard availableLanguages.contains(language), language != currentLanguage else {
                return
            }
            UserDefaults.standard.set(language, forKey: currentLanguageKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    /// first language from Bundle.main.preferredLocalizations
    public var defaultLanguage: String {
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first,
            availableLanguages.contains(preferredLanguage)
            else { return devLanguage }
        return preferredLanguage
    }
    
    /// Full localized language name
    public func displayName(for language: String) -> String? {
        let locale = NSLocale(localeIdentifier: currentLanguage)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return nil
    }
    
    /// full names
    public var displayLanguages: [String] {
        return availableLanguages.flatMap { displayName(for: $0) }
    }
    
    /// check for rightToLeft language
    public var isCurrentLanguageRTL: Bool {
        return Locale.characterDirection(forLanguage: currentLanguage) == .rightToLeft
    }
    
    /// you have to use 'var localizedBundle: String' of 'extension String'
    /// but there is no class substitution Bundle.main to BundleEx
    public func setForBundle(language: String, complitionHandler: (() -> Void)?) {
        appleLanguage = language
        currentLanguage = language
        forceLanguageDirectionality()
        complitionHandler?()
    }
    
    /// can be used for any NSLocalizedString method
    public func set(language: String, complitionHandler: (() -> Void)? = nil) {
        appleLanguage = language
        currentLanguage = language
        
        classSubstitution()
        forceLanguageDirectionality()
        substitutionMainBundle(for: language)
        complitionHandler?()
    }
    
    /// dispatch once token. set only one time
    private var onceToken = true
    /// replace Bundle.main vs BundleEx.self. will be chnaged one time only
    private func classSubstitution() {
        if onceToken {
            object_setClass(Bundle.main, BundleEx.self)
            onceToken = false
        }
    }
    
    /// will change view directionality to current language
    private func forceLanguageDirectionality() {
        if isCurrentLanguageRTL {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        /// maybe will be need
        
        //UserDefaults.standard.set(LocalizationManager.shared.isCurrentLanguageRTL, forKey: "AppleTextDirection")
        //UserDefaults.standard.set(LocalizationManager.shared.isCurrentLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        //UserDefaults.standard.synchronize()
    }
    
    /// save Bundle.main for language bundle for kBundleKey
    private func substitutionMainBundle(for language: String) {
        /// check for "Base" language and replace it to Default(en)
        var language = language
        if language == devLanguage {
            language = "Base"
        }
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
            else { return }
        objc_setAssociatedObject(Bundle.main, &kBundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
extension LocalizationManager {
    public var locale: Locale {
        return Locale(identifier: currentLanguage)
    }
}

/// reference for main bundle
private var kBundleKey: UInt8 = 0

/// replced Bundle.main class for using localizedString method
private final class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleKey) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        /// objc_setAssociatedObject(Bundle.main, &kBundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        fatalError("you need to set Bundle main for kBundleKey")
    }
}
