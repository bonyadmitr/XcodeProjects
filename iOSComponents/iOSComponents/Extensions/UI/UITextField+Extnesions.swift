//
//  UITextField+Extnesions.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder, let newValue = newValue else {
                return
            }
            let attributes: [NSAttributedStringKey: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}
