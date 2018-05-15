//
//  UINavigationBar+Text.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 10.08.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    var defaultFont: UIFont {
        return UIFont(name: "Helvetica Neue", size: 12)!
    }
    
    var font: UIFont {
        set{
            titleTextAttributes = [NSFontAttributeName : newValue]
        }
        get{
            guard let titleTextAttributes = titleTextAttributes else {
                return defaultFont
            }
            guard let guardFont = titleTextAttributes[NSFontAttributeName] as? UIFont else {
                return defaultFont
            }
            return guardFont
        }
    }
    
    // same as new font property
    func  setTextFont(font: UIFont) {
        titleTextAttributes = [NSFontAttributeName : font]
    }
    
    // tintColor
    func  setTextColor(color: UIColor) {
        titleTextAttributes = [NSForegroundColorAttributeName : color]
    }
    
    func setShadow(shadow: NSShadow) {
        titleTextAttributes = [NSShadowAttributeName : shadow]
    }
}


