//
//  UITextField+Properties.swift
//  OLPortal
//
//  Created by Bondar Yaroslav on 24/03/2017.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// Placeholder color
    @IBInspectable var placeholderColor: UIColor {
        get {
            fatalError("Swift extensions cannot add stored properties. Use for set only")
        }
        set {
            let att = [NSAttributedString.Key.foregroundColor: newValue]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: att)
        }
    }
}
