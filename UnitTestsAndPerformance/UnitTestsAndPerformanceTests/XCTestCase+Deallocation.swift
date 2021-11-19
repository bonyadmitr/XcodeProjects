import XCTest

/// custom assertions
/// https://www.bignerdranch.com/blog/creating-a-custom-xctest-assertion/
/// https://medium.com/@amlcurran/custom-assertions-in-swift-3b91b413665e

/// test Memory leaks
/// https://swiftrocks.com/unit-testing-weak-references--deallocation-in-swift
/// https://www.avanderlee.com/swift/memory-leaks-unit-tests/
/// https://github.com/leandromperez/specleaks/blob/master/SpecLeaks/Classes/AnalyzeLeak.swift
extension XCTestCase {
    
    static let autoreleasepoolExpectationtTmeout: TimeInterval = 3
    
    func assertDeallocation(file: StaticString = #file, line: UInt = #line, _ constructor: () -> AnyObject) {
        weak var mayBeLeakingRef: AnyObject?
        autoreleasepool {
            mayBeLeakingRef = constructor()
        }
        XCTAssertNil(mayBeLeakingRef, file: file, line: line)
    }
    
    /// expectation realization, but we don't need to sync autoreleasepool
    //func assertDeallocation(file: StaticString = #file, line: UInt = #line, _ constructor: () -> AnyObject) {
    //    weak var mayBeLeakingRef: AnyObject?
    //
    //    let autoreleasepoolExpectation = expectation(description: "Autoreleasepool should drain")
    //    autoreleasepool {
    //        mayBeLeakingRef = constructor()
    //        autoreleasepoolExpectation.fulfill()
    //    }
    //
    //    wait(for: [autoreleasepoolExpectation], timeout: XCTestCase.autoreleasepoolExpectationtTmeout)
    //    XCTAssertNil(mayBeLeakingRef, file: file, line: line)
    //}
    
    /// Verifies whether the given constructed UIViewController gets deallocated after being presented and dismissed.
    ///
    /// - Parameter testingViewController: The view controller constructor to use for creating the view controller.
    func assertDeallocationPresentedVC(file: StaticString = #file, line: UInt = #line, of testedViewController: () -> UIViewController) {
        weak var weakReferenceViewController: UIViewController?
        
        let autoreleasepoolExpectation = expectation(description: "Autoreleasepool should drain")
        autoreleasepool {
            let rootViewController = UIViewController()
            
            // Make sure that the view is active and we can use it for presenting views.
            //let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            let window = UIWindow()
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            
            /// Present and dismiss the view after which the view controller should be released.
            rootViewController.present(testedViewController(), animated: false, completion: {
                weakReferenceViewController = rootViewController.presentedViewController
                XCTAssertNotNil(weakReferenceViewController, file: file, line: line)
                
                rootViewController.dismiss(animated: false, completion: {
                    autoreleasepoolExpectation.fulfill()
                })
            })
        }
        
        wait(for: [autoreleasepoolExpectation], timeout: XCTestCase.autoreleasepoolExpectationtTmeout)
        
        XCTAssertNil(weakReferenceViewController, file: file, line: line)
        //wait(for: weakReferenceViewController == nil, timeout: 3.0, description: "The view controller should be deallocated since no strong reference points to it.")
    }
    
    /// Checks for the callback to be the expected value within the given timeout.
    ///
    /// - Parameters:
    ///   - condition: The condition to check for.
    ///   - timeout: The timeout in which the callback should return true.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
//    private func wait(for condition: @autoclosure @escaping () -> Bool, timeout: TimeInterval, description: String, file: StaticString = #file, line: UInt = #line) {
//        
//        let end = Date().addingTimeInterval(timeout)
//        var value = false
//        
//        let closure: () -> Void = {
//            value = condition()
//        }
//        
//        while !value && 0 < end.timeIntervalSinceNow {
//            if RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.002)) {
//                Thread.sleep(forTimeInterval: 0.002)
//            }
//            closure()
//        }
//        
//        closure()
//        
//        XCTAssertTrue(value, "➡️? Timed out waiting for condition to be true: \"\(description)\"", file: file, line: line)
//    }
}
