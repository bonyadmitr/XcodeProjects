import XCTest

extension XCUIElement {
    
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
