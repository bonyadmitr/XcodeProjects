//
//  Date+MilliSec.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 02.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import Foundation

extension Date {
    init (since1970InMilliSec seconds: Double) {
        self.init(timeIntervalSince1970: seconds * 0.001)
    }
    
    init (since1970InMilliSec seconds: Int64) {
        self.init(timeIntervalSince1970: Double(seconds) * 0.001)
    }
    
    var since1970InMilliSec: Int64 {
        return Int64(timeIntervalSince1970) * 1000
    }
}
