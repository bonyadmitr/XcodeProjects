//
//  SwiftCheckbox.swift
//  IBDesignableDemo
//
//  Created by Nick Griffith on 2/25/15.
//  Copyright (c) 2015 nhg. All rights reserved.
//

import UIKit

@IBDesignable class DesignableCheckbox: UIControl {
  
    override var description: String {
        get {
            return "<UICheckbox>: checked? \(self.checked)"
        }
    }
    
    override var backgroundColor: UIColor? {
        set(newColor) {
            super.backgroundColor = UIColor.clearColor()          
            self._backgroundColor = newColor ?? UIColor.clearColor()
        }
        get {
            return self._backgroundColor
        }
    }

    private var _backgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var checked: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var checkmarkSize: CGFloat = 5.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var checkmarkColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var filled: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var checkedFillColor: UIColor = UIColor(red: 0.078, green: 0.435, blue: 0.875, alpha: 1.0) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var uncheckedFillColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.touchInside) {
            self.checked = !self.checked
            self.sendActionsForControlEvents(.ValueChanged)
        }
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    private var currentFillColor: UIColor {
        get {
            if self.checked {
                return self.checkedFillColor
            } else if self.filled {
                return self.uncheckedFillColor
            } else {
                return UIColor.clearColor()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        let shadowColor = UIColor.blackColor()
        
        let shadowOffset = CGSizeMake(0.1, -0.1)
        let shadowBlurRadius: CGFloat = 2.5
        
        var frame = rect
        if frame.size.width != frame.size.height {
            let shortestSide = min(frame.size.width, frame.size.height)
            let longestSide = max(frame.size.width, frame.size.height)
            
            let originY = (longestSide - frame.size.width) / 2
            let originX = (longestSide - frame.size.height) / 2
            
            frame = CGRectMake(originX, originY, shortestSide, shortestSide)
        }
        
        let group = CGRectInset(frame, self.borderWidth/2, self.borderWidth/2)
        
        let ovalPath = UIBezierPath(ovalInRect: group)
        CGContextSaveGState(context!)
        CGContextSetShadowWithColor(context!, shadowOffset, shadowBlurRadius, shadowColor.CGColor)
        
        self.currentFillColor.setFill()
        ovalPath.fill()
        CGContextRestoreGState(context!)
        
        self.borderColor.setStroke()
        ovalPath.lineWidth = self.borderWidth
        ovalPath.stroke()
        
        if self.checked || self.filled {
            let checkPath = UIBezierPath()
            
            let startX = CGRectGetMinX(group) + 0.27083 * CGRectGetWidth(group)
            let startY = CGRectGetMinY(group) + 0.54167 * CGRectGetHeight(group)
            let startPoint = CGPointMake(startX, startY)
            
            let midX = CGRectGetMinX(group) + 0.41667 * CGRectGetWidth(group)
            let midY = CGRectGetMinY(group) + 0.68750 * CGRectGetHeight(group)
            let midPoint = CGPointMake(midX, midY)
            
            let endX = CGRectGetMinX(group) + 0.75000 * CGRectGetWidth(group)
            let endY = CGRectGetMinY(group) + 0.35417 * CGRectGetHeight(group)
            let endPoint = CGPointMake(endX, endY)
            
            checkPath.moveToPoint(startPoint)
            checkPath.addLineToPoint(midPoint)
            checkPath.addLineToPoint(endPoint)
            checkPath.lineCapStyle = .Square
            checkPath.lineWidth = self.checkmarkSize
            self.checkmarkColor.setStroke()
            
            CGContextSetBlendMode(context!, .Clear)
            checkPath.stroke()
            CGContextSetBlendMode(context!, .Normal)
            checkPath.stroke()
        }
    }
}
