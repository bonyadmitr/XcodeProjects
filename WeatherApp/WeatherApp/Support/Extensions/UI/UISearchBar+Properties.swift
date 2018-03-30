//
//  UISearchBar+Properties.swift
//  OLPortal
//
//  Created by Bondar Yaroslav on 24/03/2017.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

extension UISearchBar {
    // swiftlint:disable force_cast
    /// for colors only
    var textField: UITextField {
        return self.value(forKey: "searchField") as! UITextField
    }
    
    /// text color
    @IBInspectable var textColor: UIColor? {
        get {
            return textField.textColor
        }
        set {
            textField.textColor = newValue
        }
    }
    
    /// Search image color
    @IBInspectable var searchImageColor: UIColor {
        get {
//            fatalError("Swift extensions cannot add stored properties. Use for set only")
            let glassIconView = textField.leftView as? UIImageView
            return glassIconView?.tintColor ?? UIColor.white
        }
        set {
            let glassIconView = textField.leftView as? UIImageView
            glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
            glassIconView?.tintColor = newValue
        }
    }
    
    /// Clear button color
    @IBInspectable var clearButtonColor: UIColor {
        get {
//            fatalError("Swift extensions cannot add stored properties. Use for set only")
            let clearButton = textField.value(forKey: "clearButton") as! UIButton
            return clearButton.tintColor
        }
        set {
            let clearButton = textField.value(forKey: "clearButton") as! UIButton
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = newValue
        }
    }
    
    /// Can't be set less then default cornerRadius (like textFieldCornerRadius = 0)
    @IBInspectable var textFieldCornerRadius: Float {
        get {
            return Float(textField.layer.cornerRadius)
        }
        set {
            textField.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    /// Set text field round sides
    @IBInspectable var isRoundTextField: Bool {
        get {
            return textFieldCornerRadius == 14
        }
        set {
            textFieldCornerRadius = 14
        }
    }
    
    /// Set search bar placeholder color
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return textField.placeholderColor
        }
        set {
            textField.placeholderColor = placeholderColor
        }
    }
    
    /// will set placeholder text with placeholder color
    /// if you will use default 'placeholder' property, placeholder color will be setted to default (70% gray)
    @IBInspectable var placeholderColorText: String? {
        get {
            return placeholder
        }
        set {
            textField.placeholder = newValue
            textField.placeholderColor = textField.placeholderColor
        }
    }
    
    // swiftlint:enable force_cast
}
