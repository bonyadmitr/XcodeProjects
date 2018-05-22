//
//  CGRect+WithNew.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 25.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    func withHeight(height: CGFloat) -> CGRect {
        var rect = self
        rect.size.height = height
        return rect
    }

    func withWidth(width: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = width
        return rect
    }
    
    func withY(y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = y
        return rect
    }
    
    func withX(x: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x
        return rect
    }
    
    func withOrigin(origin: CGPoint) -> CGRect {
        var rect = self
        rect.origin = origin
        return rect
    }
    
    func withSize(size: CGSize) -> CGRect {
        var rect = self
        rect.size = size
        return rect
    }
}