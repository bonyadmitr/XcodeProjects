import XCTest

/// DON'T use "private" for test functions

/// extensions  https://github.com/PGSSoft/AutoMate/blob/master/AutoMate/XCTest%20extensions/XCUIElement.swift
/// extensions https://github.com/PGSSoft/AutoMate/blob/master/AutoMate/XCTest%20extensions/XCUIElement%2BSwipe.swift

/// launchArguments https://medium.com/flawless-app-stories/speeding-up-automated-tests-in-ios-fdf20080710e
/// XCTContext.runActivity https://qualitytesting.tumblr.com/post/161515906184/easier-debugging-with-xctactivity-and
final class ProductsListUITests: XCTestCase {

    private var app: XCUIApplication!
    
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
    
    func test_scrollList_and_select() {
        let collectionView = app.collectionViews.firstMatch
        
        XCTContext.runActivity(named: "scroll") { _ in
            collectionView.swipeUp()
            collectionView.swipeUp()
        }
        
        XCTContext.runActivity(named: "cell tap") { _ in
            let cell = collectionView.cells.element(boundBy: 4)
            cell.tap()
        }
        
        checkApp()
    }
    
    func test_ProductDetailController_and_PopBack() {
        
        XCTContext.runActivity(named: "cell tap") { _ in
            let cell = app.collectionViews.cells.firstMatch
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
            } else {
                /// close popup with error
                app.buttons["OK"].tap()
            }
        }
        
        checkApp()
    }
    
    func test_search() {
        let productsNavigationBar = app.navigationBars.firstMatch
        let searchBar = productsNavigationBar.searchFields.firstMatch
        //productsNavigationBar.searchFields["Search name/price/description"]
        searchBar.tap()
        
//        let aKey = app.keys["a"]
//        aKey.tap()
//
//        let pKey = app.keys["p"]
//        pKey.tap()
//        pKey.tap()
//
//        let lKey = app.keys["l"]
//        lKey.tap()
        searchBar.typeText("appl")
        
        app.collectionViews.cells.firstMatch.tap()
        //productsNavigationBar.buttons["Products"].tap() /// back
        app.swipeBack()
        productsNavigationBar.buttons["Cancel"].tap()
        
        checkApp()
    }
    
    func test_searchSorting() {
        let productsNavigationBar = app.navigationBars.firstMatch
        let searchBar = productsNavigationBar.searchFields.firstMatch
        searchBar.tap()
        
        productsNavigationBar.buttons["Created Date"].tap()
        productsNavigationBar.buttons["Name"].tap()
        productsNavigationBar.buttons["Created Date"].tap()
        app.collectionViews.cells.firstMatch.tap()
        app.swipeBack()
        productsNavigationBar.buttons["Cancel"].tap()
        
        checkApp()
    }
    
    func test_searchSortingScroll() {
        let productsNavigationBar = app.navigationBars.firstMatch
        let searchBar = productsNavigationBar.searchFields.firstMatch
        searchBar.tap()
        productsNavigationBar.buttons["Created Date"].tap()
        
        let collectionView = app.collectionViews.firstMatch
        collectionView.swipeUp()
        productsNavigationBar.buttons["Name"].tap()
        collectionView.swipeUp()
        
        checkApp()
    }
    
    private func checkApp() {
        XCTContext.runActivity(named: "app.isEnabled") { _ in
            sleep(1)

            /// to handle possible crash
            /// can be put into "override func tearDown()"
            XCTAssertTrue(app.isEnabled)
        }
    }
    
    //private func tapAnyCell() {
    //    XCTContext.runActivity(named: "cell tap") { _ in
    //        let cell = app.collectionViews.cells.firstMatch
    //        cell.tap()
    //        sleep(1)
    //    }
    //}
    
    /// if there is no cell, it will fail on cell.tap()
    //private func waitAnyCell() -> XCUIElement {
    //    let cell = app.collectionViews.cells.firstMatch
    //    //let cell = app.collectionViews.cells.firstMatch.children(matching: .other).element
    //    XCTAssertTrue(cell.waitForExistence(timeout: 2))
    //    return cell
    //}

    //func testLaunchPerformance() {
    //    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
    //        // This measures how long it takes to launch your application.
    //        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
    //            XCUIApplication().launch()
    //        }
    //    }
    //}
}
