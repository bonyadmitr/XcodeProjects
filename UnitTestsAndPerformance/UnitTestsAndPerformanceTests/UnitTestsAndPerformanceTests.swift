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

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDeallocation() {
        assertDeallocation { () -> UIViewController in
            return ViewController()
//            let bucket = Bucket()
//            let viewModel = OwnedBucketViewModel(bucket: bucket)
//            return OwnedBucketViewController(viewModel: viewModel)
        }
    }

}
