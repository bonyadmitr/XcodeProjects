//
//  UIColor+Adjust.swift
//  CustomViews
//
//  Created by Bondar Yaroslav on 15.12.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIColor {
    
    open func lighter(by percentage: CGFloat = 30) -> UIColor? {
        return adjust(by: abs(percentage) )
    }
    
    open func darker(by percentage: CGFloat = 30) -> UIColor? {
        return adjust(by: -1 * abs(percentage) )
    }
    
    open func adjust(by percentage: CGFloat = 30) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        return UIColor(red: min(r + percentage/100, 1.0),
                       green: min(g + percentage/100, 1.0),
                       blue: min(b + percentage/100, 1.0),
                       alpha: a)
    }
    
    open func gradient(with color: UIColor, percentage: CGFloat = 30) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        var toR: CGFloat = 0, toG: CGFloat = 0, toB: CGFloat = 0, toA: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        guard color.getRed(&toR, green: &toG, blue: &toB, alpha: &toA) else {
            return nil
        }

        return UIColor(red: max(min(r + (toR - r)*percentage/100, 1.0), 0),
                       green: max(min(g + (toG - g)*percentage/100, 1.0), 0),
                       blue: max(min(b + (toB - b)*percentage/100, 1.0), 0),
                       alpha: max(min(a + (toA - a)*percentage/100, 1.0), 0))
    }
}
