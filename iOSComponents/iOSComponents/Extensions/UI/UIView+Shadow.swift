//
//  UIView+Shadow.swift
//  ChartsTest
//
//  Created by Yaroslav Bondar on 12.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import UIKit

extension UIView {
    
    public func addShadow(offsetX: CGFloat, offsetY: CGFloat, radius: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: offsetX,  height: offsetY)
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
    }
}
