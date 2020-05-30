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
        assertDeallocationPresentedVC { () -> UIViewController in
            let vc = RetainableController()
            vc.isRetained = false
            return vc
        }
    }
    
    // TODO: create bool return and check Deallocation.
    // TODO: assertDeallocation for array
    /// This one must fail
    func testDeallocation2() {
        assertDeallocationPresentedVC {
            let vc = RetainableController()
            vc.isRetained = true
            return vc
        }
    }
    
    func testDeallocation3() {
        
        assertDeallocation {
            let book = Book()
            let page = Page(book: book)
            book.add(page)
            return book
        }
        
        assertDeallocation {
            let some1 = SomeClass()
            let some2 = SomeClass()
            some1.some = some2
            some2.some = some1
            return some1
        }
        
        assertDeallocation {
            return ClosureClass()
        }
        
        assertDeallocation {
            /// viewDidLoad() not called and it is not retained
            let vc = RetainableController()
            vc.isRetained = true
            return vc
        }
    }
}

final class SomeClass {
    weak var some: AnyObject?
}

final class ClosureClass {
    var handler: (() -> Void)?
    
    init() {
        handler = { [weak self] in
            self?.someFunc()
        }
        
        //handler = someFunc
        
//        handler = {
//            self.someFunc()
//        }
    }
    
    func someFunc() {
        print("-")
    }
}


/// https://medium.com/mackmobile/avoiding-retain-cycles-in-swift-7b08d50fe3ef
class Book {
    private var pages = [Page]()
    
    func add(_ page : Page) {
        pages.append(page)
    }
}

class Page {
    private weak var book : Book?
    
    required init(book : Book) {
        self.book = book
    }
}

