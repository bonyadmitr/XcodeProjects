//
//  Date+New.swift
//  FetchedResultsController
//
//  Created by Bondar Yaroslav on 9/18/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Date {
    var withoutSeconds: Date {
        let time = floor(timeIntervalSinceReferenceDate / 60.0) * 60.0
        return Date(timeIntervalSinceReferenceDate: time)
    }
    
    var nextDay: Date {
        return Date(timeIntervalSince1970: timeIntervalSince1970 + 3600 * 24)
        /// return optional
        //Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    static var tommorow: Date {
        return Date(timeIntervalSinceNow: 3600 * 24)
    }
}
