//
//  UIView+Layer.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 09/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
