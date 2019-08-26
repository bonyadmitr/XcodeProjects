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
            let vc = ViewController()
            vc.isRetained = false
            return vc
        }
    }
    
    /// it must fail only for example. can be create bool return and check it. !!!
    func testDeallocation2() {
        assertDeallocationPresentedVC {
            let vc = ViewController()
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
            return WWW()
        }
        
        assertDeallocation {
            let vc = ViewController()
            vc.isRetained = true
            return vc
        }
    }
}

final class SomeClass {
    weak var some: AnyObject?
}

final class WWW {
    var w: (() -> Void)?
    
    init() {
        //w = ww
        
        w = {
            self.ww()
        }
        
        w = { [weak self] in
            self?.ww()
        }
    }
    
    func ww() {
        print("-")
    }
}


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

