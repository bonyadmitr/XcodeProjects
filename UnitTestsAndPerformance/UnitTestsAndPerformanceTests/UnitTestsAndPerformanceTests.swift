//
//  UnitTestsAndPerformanceTests.swift
//  UnitTestsAndPerformanceTests
//
//  Created by Yaroslav Bondar on 23/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import XCTest
@testable import UnitTestsAndPerformance

final class UnitTestsAndPerformanceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testDeallocation1() {
        assertDeallocation { () -> UIViewController in
            let vc = ViewController()
            vc.isRetained = false
            return vc
        }
    }

    func testDeallocation2() {
        assertDeallocation {
            let vc = ViewController()
            vc.isRetained = true
            return vc
        }
    }
}
