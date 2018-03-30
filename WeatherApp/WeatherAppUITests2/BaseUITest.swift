//
//  BaseUITest.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 24/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

/// SimulatorStatusMagic for CocoaPods
import SimulatorStatusMagiciOS
import XCTest

class BaseUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        /// interface orientation
        //XCUIDevice().orientation = .landscapeLeft
        
        /// In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        /// start with fastlane snapshot
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        setupSDStatusBarManager()
    }
    
    
    override open func tearDown() {
        super.tearDown()
        SDStatusBarManager.sharedInstance()?.disableOverrides()
    }
    
    func tap(_ viewLabel: String) {
        app.buttons[viewLabel].tap()
    }
    
    func tapCell(_ cellLabel: String) {
        app.tables.cells.containing(.staticText, identifier: cellLabel).element(boundBy: 0).tap()
    }
    
    private func setupSDStatusBarManager() {
        
        guard let statusBarManager = SDStatusBarManager.sharedInstance() else { return }
        
        /// setup SDStatusBarManager for clear status bar
        print("deviceLanguage: ", deviceLanguage)
        print("locale: ", locale)
        
        if deviceLanguage == "ru-RU" && locale == "ru-RU" {
            statusBarManager.carrierName = "Moscow"
            ///statusBarManager.timeString = "9:41 rus"
            ///statusBarManager.batteryDetailEnabled = false
            ///statusBarManager.bluetoothState = .visibleConnected
        }
        statusBarManager.timeString = "9:41"
        statusBarManager.enableOverrides()
    }
    
}
