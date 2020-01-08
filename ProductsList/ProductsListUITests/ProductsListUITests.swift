//
//  ProductsListUITests.swift
//  ProductsListUITests
//
//  Created by Bondar Yaroslav on 1/8/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import XCTest

class ProductsListUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

                
        // In UI tests it is usually best to stop immediately when a failure occurs.
        //
        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = false

        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        //app.launchArguments.append("--uitesting")
        app.launchArguments.append("DISABLE_ANIMATIONS")
        
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_previewDismiss() {
        /// wait cells appear after network request
        //let cell = app.cells["IMG_0352.JPG"].firstMatch
        let cell = app.collectionViews.cells.firstMatch
        //let cell = app.collectionViews.cells.firstMatch.children(matching: .other).element
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        
        /// open popup
        cell.press(forDuration: 1.0)
        
        /// check popup
        let isPopupExists = app.scrollViews.otherElements.buttons["Share"].exists
        XCTAssertTrue(isPopupExists)
        
        /// close popup
        app.swipeDown()
        //app.tap()
        
        /// wait popup close
        sleep(1)
        
        /// to handle possible crash
        /// can be put into "override func tearDown()"
        XCTAssertTrue(app.isEnabled)
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
