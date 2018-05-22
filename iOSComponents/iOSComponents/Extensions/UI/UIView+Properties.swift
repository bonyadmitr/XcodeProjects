//
//  UIView+Properties.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var exclusiveTap: Bool {
        get { return isExclusiveTouch }
        set { isExclusiveTouch = newValue }
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
//    @IBInspectable var shadow: Bool {
//        get {
//            return layer.shadowOpacity > 0.0
//        }
//        set {
//            if newValue == true {
//                self.addShadow()
//            }
//        }
//    }
//    
//    func addShadow(shadowColor: CGColor = UIColor.blackColor().CGColor,
//                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
//                   shadowOpacity: Float = 0.4,
//                   shadowRadius: CGFloat = 3.0) {
//        layer.shadowColor = shadowColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowRadius = shadowRadius
//    }
    
    // MARK: - Corners
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//    
//    // MARK: - Shadows
//    @IBInspectable var shadowRadius: Double {
//        get {
//            return Double(self.layer.shadowRadius)
//        }
//        set {
//            self.layer.shadowRadius = CGFloat(newValue)
//        }
//    }
//    
//    // The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
//    @IBInspectable var shadowOpacity: Float {
//        get {
//            return self.layer.shadowOpacity
//        }
//        set {
//            self.layer.shadowOpacity = newValue
//        }
//    }
//    
//    // The shadow offset. Defaults to (0, -3). Animatable.
//    @IBInspectable var shadowOffset: CGSize {
//        get {
//            return self.layer.shadowOffset
//        }
//        set {
//            self.layer.shadowOffset = newValue
//        }
//    }
//    
//    // The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
//    @IBInspectable var shadowColor: UIColor? {
//        get {
//            return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
//        }
//        set {
//            self.layer.shadowColor = newValue?.cgColor
//        }
//    }
//    
//    // Off - Will show shadow | On - Won't show shadow.
//    @IBInspectable var masksToBounds: Bool {
//        get {
//            return self.layer.masksToBounds
//        }
//        
//        set {
//            self.layer.masksToBounds = newValue
//        }
//    }
    
}
