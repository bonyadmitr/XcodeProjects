//
//  CGPoint+WithNew.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 25.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func withX(x: CGFloat) -> CGPoint {
        var p = self
        p.x = x
        return p
    }
    
    func withY(y: CGFloat) -> CGPoint {
        var p = self
        p.y = y
        return p
    }
}