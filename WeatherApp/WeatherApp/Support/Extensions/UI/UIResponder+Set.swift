//
//  UIResponder+Set.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UITextView {
    @IBInspectable var setFirstResponder: Bool {
        get {
            return isFirstResponder
        }
        set {
            if newValue { becomeFirstResponder() }
        }
    }
}

extension UITextField {
    @IBInspectable var setFirstResponder: Bool {
        get {
            return isFirstResponder
        }
        set {
            if newValue { becomeFirstResponder() }
        }
    }
}
