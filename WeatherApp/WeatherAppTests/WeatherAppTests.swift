//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Bondar Yaroslav on 23/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import XCTest

class WeatherAppTests: BaseUITests {
    
    override func setUp() {
        super.setUp()
        
        /// interface orientation
        //XCUIDevice().orientation = .landscapeLeft
        
        /// In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testMain() {
        tap("settings")
        
        tap("select_font")
        tap("cancel")
        
        tap("select_color")
        tap("cancel")
    }
}
