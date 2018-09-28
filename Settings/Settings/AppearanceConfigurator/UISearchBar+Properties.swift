//
//  UISearchBar+Properties.swift
//  OLPortal
//
//  Created by Bondar Yaroslav on 24/03/2017.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    /// for colors only
    private var textField: UITextField {
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
            fatalError("Swift extensions cannot add stored properties. Use for set only")
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
            fatalError("Swift extensions cannot add stored properties. Use for set only")
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
            fatalError("Swift extensions cannot add stored properties. Use for set only")
        }
        set {
            textField.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    /// Set text field round sides
    @IBInspectable var isRoundTextField: Bool {
        get {
            fatalError("Swift extensions cannot add stored properties. Use for set only")
        }
        set {
            textFieldCornerRadius = 14
        }
    }
}
