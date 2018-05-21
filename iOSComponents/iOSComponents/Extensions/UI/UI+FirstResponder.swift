//
//  FirstResponder.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/17/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import UIKit

extension UIView {
    var firstResponder: UIResponder? {
        if isFirstResponder {
            return self
        }
        return subviews.firstResponder
    }
}

extension UIApplication {
    var firstResponder: UIResponder? {
        return keyWindow?.subviews.firstResponder
    }
}

extension Collection where Element: UIView {
    var firstResponder: UIResponder? {
        for element in self {
            if let responder = element.firstResponder {
                return responder
            }
        }
        return nil
    }
}
