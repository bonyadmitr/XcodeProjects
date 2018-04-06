//
//  Date+Components.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 4/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol Components {
    
//    func getYear() -> Int
//    
//    func getMonth() -> Int
}

extension Date: Components {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func getMonth() -> Int {
        let calendar = Calendar.current
        
        return calendar.component(.month, from: self)
    }
    
    func getDateInFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func getTimeIntervalBetweenDateAndCurrentDate() -> Int {
        let curentDate = Date()
        let deltaDate = curentDate - self.timeIntervalSince1970
        let calendar = Calendar.current
        
        let years = calendar.component(.year, from: deltaDate) - 1970
        let monthes = calendar.component(.month, from: deltaDate) - 1
        return monthes + years * 12
    }
    
    var withoutSeconds: Date {
        let time = floor(timeIntervalSinceReferenceDate / 60.0) * 60.0
        return Date(timeIntervalSinceReferenceDate: time)
    }
}
