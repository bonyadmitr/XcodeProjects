//
//  Date+Compare.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 02.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import Foundation

extension Date {
    func compareWithoutTime(with date: Date) -> ComparisonResult {
        return NSCalendar.current.compare(self, to: date, toGranularity: .day)
    }
    
    func isEqualWithoutTime(with date: Date) -> Bool {
        return compareWithoutTime(with: date) == .orderedSame ? true : false
    }
}
