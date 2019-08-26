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

    func testDeallocation2() {
        assertDeallocationPresentedVC {
            let vc = ViewController()
            vc.isRetained = true
            return vc
        }
    }
    
    func testDeallocation3() {
        
        assertDeallocation({
            let book = Book()
            let page = Page(book: book)
            book.add(page)
            return book
        })
        
        assertDeallocation({
            let q1 = SomeClass()
            let q2 = SomeClass()
            q1.some = q2
            q2.some = q1
            return q1
        })
        
        assertDeallocation({
            return WWW()
        })
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

