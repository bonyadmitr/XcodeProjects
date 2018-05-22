//
//  Date+Components.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// addition
/// https://github.com/melvitax/DateHelper

extension Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func dateInFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// timeIntervalSinceNow
    var monthesSinceCurrentDate: Int {
        let deltaDate = Date() - timeIntervalSince1970
        let years = Calendar.current.component(.year, from: deltaDate) - 1970
        let monthes = Calendar.current.component(.month, from: deltaDate) - 1
        return monthes + years * 12
    }
    
    var withoutSeconds: Date {
        let time = floor(timeIntervalSinceReferenceDate / 60.0) * 60.0
        return Date(timeIntervalSinceReferenceDate: time)
    }
}
