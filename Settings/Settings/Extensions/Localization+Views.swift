//
//  Localization+Views.swift
//  LocalizationInspectable
//
//  Created by Bondar Yaroslav on 17/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// create localization for custom and 3rd party classes
/// maybe need replace 'lz' to 'l10n'

extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UILabel {
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized }
    }
}

extension UIButton {
    @IBInspectable public var lzTitle: String? {
        set {titleForAllStates = newValue?.localized }
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

extension UITextField {
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized }
    }
    @IBInspectable public var lzPlaceholder : String? {
        get { return placeholder }
        set { placeholder = newValue?.localized }
    }
}

extension UITextView {
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized }
    }
}

extension UIBarItem {
    @IBInspectable public var lzTitle: String? {
        get { return title }
        set { title = newValue?.localized }
    }
}

extension UINavigationItem {
    @IBInspectable public var lzTitle: String? {
        get { return title }
        set { title = newValue?.localized }
    }
    @IBInspectable public var lzPrompt: String? {
        get { return prompt }
        set { prompt = newValue?.localized }
    }
}

extension UIViewController {
    @IBInspectable public var lzTitle: String? {
        get { return title }
        set { title = newValue?.localized }
    }
}

extension UISegmentedControl {
    @IBInspectable public var lzTitle0: String? {
        get { return titleForSegment(at: 0) }
        set { setTitle(newValue?.localized, forSegmentAt: 0) }
    }
    @IBInspectable public var lzTitle1 : String? {
        get { return titleForSegment(at: 1) }
        set { setTitle(newValue?.localized, forSegmentAt: 1) }
    }
    @IBInspectable public var lzTitle2 : String? {
        get { return titleForSegment(at: 2) }
        set { setTitle(newValue?.localized, forSegmentAt: 2) }
    }
    @IBInspectable public var lzTitle3 : String? {
        get { return titleForSegment(at: 3) }
        set { setTitle(newValue?.localized, forSegmentAt: 3) }
    }
}

extension UISearchBar {
    @IBInspectable public var lzText: String? {
        get { return text }
        set { text = newValue?.localized }
    }
    @IBInspectable public var lzPlaceholder: String? {
        get { return placeholder }
        set { placeholder = newValue?.localized }
    }
    @IBInspectable public var lzPromt: String? {
        get { return prompt }
        set { prompt = newValue?.localized }
    }
}
