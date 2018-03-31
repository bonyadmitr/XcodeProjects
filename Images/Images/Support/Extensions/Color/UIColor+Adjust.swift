//
//  UIColor+Adjust.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 15.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIColor {
    
    open func lighter(by percentage: CGFloat = 30) -> UIColor {
        return adjust(by: abs(percentage) )
    }
    
    open func darker(by percentage: CGFloat = 30) -> UIColor {
        return adjust(by: -1 * abs(percentage) )
    }
    
    open func adjust(by percentage: CGFloat = 30) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return self
        }
        return UIColor(red: min(r + percentage/100, 1.0),
                       green: min(g + percentage/100, 1.0),
                       blue: min(b + percentage/100, 1.0),
                       alpha: a)
    }
}
