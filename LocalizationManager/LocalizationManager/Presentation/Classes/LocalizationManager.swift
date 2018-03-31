//
//  LocalizationManager.swift
//  LocalizationInspectable
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol LocalizationManagerDelegate {
    func languageDidChange(to language: String)
}

//TODO: TEST plurals
/// buttons with system text cannot be localized with force switch
public final class LocalizationManager: MulticastHandler {
    
    /// MulticastHandler protocol
    internal var delegates = MulticastDelegate<LocalizationManagerDelegate>()
    
    /// singleton
    public static let shared = LocalizationManager()
    
    /// development language. default is English. setup if it is defferent
    public var devLanguage = "en"
    
    /// key for AppleLanguages
    private let appleLanguageKey = "AppleLanguages"
    
    /// AppleLanguages wrapper
    private(set) var currentLanguage: String {
        get {
            return UserDefaults.standard.array(forKey: appleLanguageKey)?.first as? String ?? devLanguage
        }
        set {
            UserDefaults.standard.set([newValue], forKey: appleLanguageKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// check for rightToLeft language
    public var isCurrentLanguageRTL: Bool {
        return Locale.characterDirection(forLanguage: currentLanguage) == .rightToLeft
    }
    
    /// you have to use 'var localizedBundle: String' of 'extension String'.
    /// it don't use substitution of Bundle.main to BundleEx
    public func setForBundle(language: String) {
        currentLanguage = language
        forceLanguageDirection()
        delegates.invoke { $0.languageDidChange(to: language)}
    }
    
    /// can be used for any NSLocalizedString method
    public func set(language: String) {
        currentLanguage = language
        bundleSubstitutionOnce()
        substitutionOfMainBundle(for: language)
        forceLanguageDirection()
        delegates.invoke { $0.languageDidChange(to: language)}
    }
    
    /// dispatch once token. set only one time.
    /// can be added lock for thread safe:
    /// private let lock = NSLock() //lock.lock(); defer { lock.unlock() }
    private var onceToken = true
    /// replace Bundle.main vs BundleEx.self. will be chnaged one time only
    private func bundleSubstitutionOnce() {
        if onceToken {
            object_setClass(Bundle.main, BundleEx.self)
            onceToken = false
        }
    }
    
    /// will change view directionality to current language
    private func forceLanguageDirection() {
        if isCurrentLanguageRTL {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        /// maybe will be need
        /// https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/TestingYourInternationalApp/TestingYourInternationalApp.html
        //UserDefaults.standard.set(LocalizationManager.shared.isCurrentLanguageRTL, forKey: "AppleTextDirection")
        //UserDefaults.standard.set(LocalizationManager.shared.isCurrentLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        //UserDefaults.standard.synchronize()
    }
    
    /// save Bundle.main for language bundle for kBundleKey
    private func substitutionOfMainBundle(for language: String) {
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
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

/// Most simple realization
/// Usage: Bundle.setLanguage(language)
//var bundleKey: UInt8 = 0
//private final class AnyLanguageBundle: Bundle {    
//    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
//        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
//            let bundle = Bundle(path: path)
//        else {
//            return super.localizedString(forKey: key, value: value, table: tableName)
//        }
//        return bundle.localizedString(forKey: key, value: value, table: tableName)
//    }
//}
//extension Bundle {
//    static func setLanguage(_ language: String) {
//        defer { object_setClass(Bundle.main, AnyLanguageBundle.self) }
/// to save language: UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
//        let bundle = Bundle.main.path(forResource: language, ofType: "lproj")
//        objc_setAssociatedObject(Bundle.main, &bundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
//}
