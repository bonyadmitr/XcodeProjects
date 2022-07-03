//
//  DiskSpace.swift
//  FileManagerReview
//
//  Created by Yaroslav Bondar on 12.11.2021.
//

import Foundation

// TODO: there is DiskSpace project
/// another possible name `VolumeStorage`

extension Int {
    init(percent value: Double, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
        self.init((value * 100).rounded(rule))
    }
}

extension Double {
    
    /// Rounds the double to decimal places value
    /// inspired https://stackoverflow.com/a/32581409/5893286
    func roundedDecimalPlaces(to places: Int) -> Double {
        /// instead of `round((value * 100.0)) / 100.0`
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

