//
//  Localization+Views.swift
//  LocalizationInspectable
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// create localization for custom and 3rd party classes
extension String {
    public var localized: String {
        let str = NSLocalizedString(self, comment: "")
        if str == self {
            print("⚠️ not found localization for: \(str) in: \(LocalizationManager.shared.currentLanguage) ⚠️")
        }
        return str
    }
}

/// maybe need replace 'lz' to 'l10n'
extension UILabel {
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized ?? nil }
    }
}

extension UITextField {
    
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized ?? nil }
    }
    @IBInspectable public var lzPlaceholder: String? {
        get { return placeholder }
        set { placeholder = newValue?.localized ?? nil }
    }
}

extension UIButton {
    @IBInspectable public var lzTitle: String? {
        set { titleForAllStates = newValue?.localized ?? nil }
        get { return titleForAllStates }
    }
    public var titleForAllStates: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
            setTitle(newValue, for: .highlighted)
            setTitle(newValue, for: .disabled)
            setTitle(newValue, for: .selected)
            setTitle(newValue, for: .focused)
            setTitle(newValue, for: .application)
            setTitle(newValue, for: .reserved)
        }
    }
}

extension UIBarItem {
    @IBInspectable public var lzTitle: String? {
        get { return title }
        set { title = newValue?.localized ?? nil }
    }
}

extension UINavigationItem {
    @IBInspectable public var lzTitle: String? {
        get { return title }
        set { title = newValue?.localized ?? nil }
    }
    @IBInspectable public var lzPrompt: String? {
        get { return prompt }
        set { prompt = newValue?.localized ?? nil }
    }
}

extension UIViewController {
    @IBInspectable public var lzTitle: String? {
        get { return title }
        set { title = newValue?.localized ?? nil }
    }
}

extension UISegmentedControl {
    @IBInspectable public var lzTitle0: String? {
        get { return titleForSegment(at: 0) }
        set { setTitle(newValue?.localized ?? nil, forSegmentAt: 0) }
    }
    @IBInspectable public var lzTitle1: String? {
        get { return titleForSegment(at: 1) }
        set { setTitle(newValue?.localized ?? nil, forSegmentAt: 1) }
    }
    @IBInspectable public var lzTitle2: String? {
        get { return titleForSegment(at: 2) }
        set { setTitle(newValue?.localized ?? nil, forSegmentAt: 2) }
    }
    @IBInspectable public var lzTitle3: String? {
        get { return titleForSegment(at: 3) }
        set { setTitle(newValue?.localized ?? nil, forSegmentAt: 3) }
    }
}

extension UISearchBar {
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized ?? nil }
    }
    @IBInspectable public var lzPlaceholder: String? {
        get { return placeholder }
        set { placeholder = newValue?.localized ?? nil }
    }
    @IBInspectable public var lzPromt: String? {
        get { return prompt }
        set { prompt = newValue?.localized ?? nil }
    }
}
