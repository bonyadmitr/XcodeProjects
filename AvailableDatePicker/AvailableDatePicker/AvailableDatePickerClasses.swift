//
//  AvailableDatePickerClasses.swift
//  AvailableDatePicker
//
//  Created by Bondar Yaroslav on 02/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

internal enum DateComponent: Int {
    case year = 0
    case month = 1
    case day = 2
}

class YearClass {
    var year: Int = 0
    var months: [MonthClass] = []
    
    init() {}
    init(year: Int, month: MonthClass) {
        self.year = year
        months = [month]
    }
}
extension YearClass: CustomStringConvertible {
    var description: String {
        let monthsStr = months.map { String(describing: $0) }.joined(separator: ", ")
        let res = "year: \(year), months: [\(monthsStr)]"
        return res
    }
}


class MonthClass {
    var month: Int = 0
    var days: [Int] = []
    
    init() {}
    init(month: Int, day: Int) {
        self.month = month
        days = [day]
    }
    
    lazy var dateFormatter = DateFormatter()
    var monthName: String {
        return dateFormatter.monthSymbols[month - 1]
    }
}
extension MonthClass: CustomStringConvertible {
    var description: String {
        let daysStr = days.map { String($0) }.joined(separator: ", ")
        let res = "month: \(month), days: [\(daysStr)]"
        return res
    }
}
