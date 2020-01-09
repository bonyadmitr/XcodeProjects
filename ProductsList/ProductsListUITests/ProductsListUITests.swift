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
        
        /// https://medium.com/flawless-app-stories/speeding-up-automated-tests-in-ios-fdf20080710e
        app.launchArguments = ["-DISABLE_ANIMATIONS", "true"]
        
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
    
    func test_ProductDetailController_and_PopBack() {
        let collectionView = app.collectionViews.firstMatch
        
        XCTContext.runActivity(named: "scroll") { _ in
            collectionView.swipeUp()
            collectionView.swipeUp()
        }
        
        XCTContext.runActivity(named: "cell tap") { _ in
            let cell = collectionView.cells.element(boundBy: 4)
            cell.tap()
            sleep(1)
        }
        
        /// back / pop
        XCTContext.runActivity(named: "pop") { _ in
//            app.swipeBack()
            
            /// working
//            isHittable
            let backButton = app.navigationBars.buttons.firstMatch
            if backButton.isHittable {
                backButton.tap()
            }
        }
        
        XCTContext.runActivity(named: "app.isEnabled") { _ in
            /// wait popup close
            sleep(1)

            /// to handle possible crash
            /// can be put into "override func tearDown()"
            XCTAssertTrue(app.isEnabled)
        }
        
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

extension XCUIApplication {
    
    /// objc source https://stackoverflow.com/a/34816101/5893286
    func swipeBack() {
        let topLeftCoordinate = self.coordinate(withNormalizedOffset: .init(dx: 0.01, dy: 0.15))
        let topLeftOffsetCoordinate = topLeftCoordinate.withOffset(.init(dx: 50, dy: 0))
        topLeftCoordinate.press(forDuration: 0.5, thenDragTo: topLeftOffsetCoordinate)
        
        /// not working
        //app.windows.element(boundBy:0).swipeLeft()
        
        /// not working
        //let element = app.scrollViews.children(matching: .other).element(boundBy: 0)
        //element.swipeRight()
    }
    
}
