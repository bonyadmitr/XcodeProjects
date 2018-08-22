//
//  UIBarButtonItem+Init.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 8/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(title: String,
                     font: UIFont,
                     accessibilityLabel: String? = nil,
                     target: Any?,
                     selector: Selector?) {
        
        self.init(title: title, style: .plain, target: target, action: selector)
        self.accessibilityLabel = accessibilityLabel
        
        /// not working setTitleTextAttributes([.font : font], for: [.normal, .highlighted])
        setTitleTextAttributes([.font : font], for: .normal)
        setTitleTextAttributes([.font : font], for: .highlighted)
        setTitleTextAttributes([.font : font], for: .disabled)
        setTitleTextAttributes([.font : font], for: .selected)
    }
}
