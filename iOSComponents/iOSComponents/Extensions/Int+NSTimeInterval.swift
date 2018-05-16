//
//  Int+NSTimeInterval.swift
//  SwiftBest
//
//  Created by zdaecqze zdaecq on 25.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Int {
    var minutes: NSTimeInterval {
        return self.toDouble * 60
    }
    var hours: NSTimeInterval {
        return self.minutes * 60
    }
    var days: NSTimeInterval {
        return self.toDouble * 24.hours
    }
    var weeks: NSTimeInterval {
        return self.toDouble * 7.days
    }
}