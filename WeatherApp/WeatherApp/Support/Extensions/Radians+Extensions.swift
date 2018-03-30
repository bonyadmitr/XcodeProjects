//
//  Radians+Extensions.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 02/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import CoreGraphics

extension IntegerLiteralType {
    var radians: CGFloat { return CGFloat(self) * .pi / 180 }
}
extension FloatingPoint {
    var radians: Self { return self * .pi / 180 }
    var degrees: Self { return self * 180 / .pi }
}
