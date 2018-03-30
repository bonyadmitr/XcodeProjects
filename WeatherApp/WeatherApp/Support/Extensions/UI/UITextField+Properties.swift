//
//  UITextField+Properties.swift
//  OLPortal
//
//  Created by Bondar Yaroslav on 24/03/2017.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

extension UITextField {
    
    private static let association = AssociationManager<UIColor>()
    
    /// Placeholder color
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return UITextField.association[self]
        }
        set {
            guard let value = newValue else { return }
            UITextField.association[self] = value
            
            let att: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: value,
                                                      NSAttributedStringKey.font: font!]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: att)
        }
    }
}
