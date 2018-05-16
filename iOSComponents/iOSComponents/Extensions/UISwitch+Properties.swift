//
//  UISwitch+Extensions.swift
//  SwiftBest
//
//  Created by Yaroslav Bondar on 25.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UISwitch {
    
    func setOffColor(color: UIColor) {
        tintColor = color
        backgroundColor = color
        layer.cornerRadius = 16.0
        layer.masksToBounds = true
    }
    
    func setOnColor(color: UIColor) {
        onTintColor = color
    }
    
    func setSizeScale(scale: CGFloat) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
