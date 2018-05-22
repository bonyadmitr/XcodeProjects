//
//  UIView+Self.swift
//  Swift3Best
//
//  Created by Bondar Yaroslav on 06/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// Example
//_ = view
//    .backgroundColor(UIColor.red)
//    .cornerRadius(10)
//    .masksToBounds(true)
//    .borderColor(UIColor.black)
//    .borderWidth(2)
extension UIView {
    
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        return self
    }
    func masksToBounds(_ masksToBounds: Bool) -> Self {
        layer.masksToBounds = masksToBounds
        return self
    }
    func borderWidth(_ borderWidth: CGFloat) -> Self {
        layer.borderWidth = borderWidth
        return self
    }
    func borderColor(_ borderColor: UIColor) -> Self {
        layer.borderColor = borderColor.cgColor
        return self
    }
}
