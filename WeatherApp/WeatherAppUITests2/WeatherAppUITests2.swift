//
//  WeatherAppUITests2.swift
//  WeatherAppUITests2
//
//  Created by Bondar Yaroslav on 23/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import XCTest

class WeatherAppUITests2: BaseUITest {
    
    func testScreenshots() {
        snapshot("01_main")
        
        tap("settings")
        snapshot("02_settings")
        
        tap("select_font")
        snapshot("03_select_font")
        //tapCell("ArialHebrew")
        tap("cancel")
        
        tap("select_color")
        snapshot("04_select_color")
        tap("cancel")
    }
}
