//
//  YearMonth.swift
//  ScrollBar
//
//  Created by Bondar Yaroslav on 10/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

struct YearMonth {
    let year: Int
    let month: Int
    
    init(date: Date) {
        let comps = Calendar.current.dateComponents([.year, .month], from: date)
        self.year = comps.year!
        self.month = comps.month!
    }
}
extension YearMonth: Hashable {
    var hashValue: Int {
        return year * 12 + month
    }
}
extension YearMonth: Equatable {
    static func == (lhs: YearMonth, rhs: YearMonth) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month
    }
}
extension YearMonth: Comparable {
    static func < (lhs: YearMonth, rhs: YearMonth) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else {
            return lhs.month < rhs.month
        }
    }
}
