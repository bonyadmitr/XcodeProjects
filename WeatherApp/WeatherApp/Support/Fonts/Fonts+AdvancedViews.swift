//
//  Fonts+AdvancedViews.swift
//  Customization
//
//  Created by Bondar Yaroslav on 20/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// need AssociationManager or delete

/// recomend to create subclass or use UIAppearance
extension UISegmentedControl {
    
    private static let associationFontSize = AssociationManager<CGFloat>()
    @IBInspectable public var fontSize: CGFloat {
        get {
            return UISegmentedControl.associationFontSize[self] ?? 15
        }
        set {
            UISegmentedControl.associationFontSize[self] = newValue
            
            var font: UIFont!
            if let type = fontType {
                font = Fonts(rawValue: type)?.font(with: newValue)
            } else {
                font = Fonts.base.font(with: newValue)
            }
            set(font: font)
        }
    }
    
    private static let associationFontType = AssociationManager<String>()
    @IBInspectable public var fontType: String? {
        get {
            return UISegmentedControl.associationFontType[self]
        }
        set {
            UISegmentedControl.associationFontType[self] = newValue
            guard
                let value = newValue,
                let type = Fonts(rawValue: value)
                else {
                    return print("- there is no font type: \(newValue ?? "nil")")
            }
            set(font: type.font(with: fontSize))
        }
    }
    
    func set(font: UIFont) {
        let attr = [NSAttributedStringKey.font: font]
        setTitleTextAttributes(attr, for: .normal)
    }
}

/// recomend to create subclass or use UIAppearance
extension UIBarItem {
    
    private static let associationFontSize = AssociationManager<CGFloat>()
    @IBInspectable public var fontSize: CGFloat {
        get {
            return UIBarItem.associationFontSize[self] ?? 15
        }
        set {
            UIBarItem.associationFontSize[self] = newValue
            
            var font: UIFont!
            if let type = fontType {
                font = Fonts(rawValue: type)?.font(with: newValue)
            } else {
                font = Fonts.base.font(with: newValue)
            }
            set(font: font)
        }
    }
    
    private static let associationFontType = AssociationManager<String>()
    @IBInspectable public var fontType: String? {
        get {
            return UIBarItem.associationFontType[self]
        }
        set {
            UIBarItem.associationFontType[self] = newValue
            guard
                let value = newValue,
                let type = Fonts(rawValue: value)
                else {
                    return print("- there is no font type: \(newValue ?? "nil")")
            }
            set(font: type.font(with: fontSize))
        }
    }
    
    func set(font: UIFont) {
        let attr = [NSAttributedStringKey.font: font]
        setTitleTextAttributes(attr, for: .normal)
    }
}

/// recomend to create subclass or use UIAppearance
extension UINavigationBar {
    
    private static let associationFontSize = AssociationManager<CGFloat>()
    @IBInspectable public var fontSize: CGFloat {
        get {
            return UINavigationBar.associationFontSize[self] ?? 15
        }
        set {
            UINavigationBar.associationFontSize[self] = newValue
            
            var font: UIFont!
            if let type = fontType {
                font = Fonts(rawValue: type)?.font(with: newValue)
            } else {
                font = Fonts.base.font(with: newValue)
            }
            set(font: font)
        }
    }
    
    private static let associationFontType = AssociationManager<String>()
    @IBInspectable public var fontType: String? {
        get {
            return UINavigationBar.associationFontType[self]
        }
        set {
            UINavigationBar.associationFontType[self] = newValue
            guard
                let value = newValue,
                let type = Fonts(rawValue: value)
                else {
                    return print("- there is no font type: \(newValue ?? "nil")")
            }
            set(font: type.font(with: fontSize))
        }
    }
    
    func set(font: UIFont) {
        titleTextAttributes = [NSAttributedStringKey.font: font]
    }
}
