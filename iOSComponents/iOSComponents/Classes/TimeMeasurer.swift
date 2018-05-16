//
//  TimeMeasurer.swift
//  TimeMeasurer
//
//  Created by Bondar Yaroslav on 14/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

class TimeMeasurer {
    
    static let shared = TimeMeasurer()
    
    private var startTime: Date!
    
    func start() {
        startTime = Date()
    }
    func finish(title: String = "finished:") {
        print("TM", title, Date().timeIntervalSince(startTime))
    }
    
    func measure(title: String = "TM measured:", handler: ()->Void) {
        let startTime = Date()
        handler()
        print("TM", title, Date().timeIntervalSince(startTime))
    }
}
