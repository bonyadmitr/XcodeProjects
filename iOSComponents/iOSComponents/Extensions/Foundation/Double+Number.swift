//
//  Double+Number.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 02.08.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Foundation

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}