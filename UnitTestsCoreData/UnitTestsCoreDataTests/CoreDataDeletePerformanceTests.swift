//
//  CoreDataDeletePerformanceTests.swift
//  UnitTestsCoreDataTests
//
//  Created by Bondar Yaroslav on 12/11/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
@testable import UnitTestsCoreData
import XCTest
import CoreData

/// old perfermance tests
/// https://github.com/bizz84/MVCoreDataStack

//final class CoreDataDeleteOldApiSQLPerformanceTests: CoreDataDeleteMemoryPerformanceTests {
//    override class func setUp() {
//        super.setUp()
//        coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName, oldApi: true)
//    }
//}
//
//final class CoreDataDeleteOldApiMemoryPerformanceTests: CoreDataDeleteMemoryPerformanceTests {
//    override class func setUp() {
//        super.setUp()
//        coreDataStack = CoreDataStack(storeType: .memory, modelName: modelName, oldApi: true)
//    }
//}
//
//final class CoreDataDeleteSQLPerformanceTests: CoreDataDeleteMemoryPerformanceTests {
//    override class func setUp() {
//        super.setUp()
//        coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName)
//    }
//}

extension Double {
    func toInt() -> Int? {
        return (Double(Int.min).nextUp...Double(Int.max).nextDown ~= self) ? Int(self) : nil
    }
    
    func toInt2() -> Int? {
        guard self < Double(Int.max), self > Double(Int.min) else {
            return nil
        }
        return Int(self)
    }
    
    func toInt3() -> Int? {
        if self < Double(Int.max), self > Double(Int.min) {
            return Int(self)
        }
        return nil
    }
}

/// If your test is more than 10% slower than the baseline, it'll fail
class CoreDataDeleteMemoryPerformanceTests: XCTestCase {
    
    func testQQQ1() {
        measure {
            for _ in 1...1000 {
                _ = Double(0).toInt()
                _ = Double(1000000000).toInt()
                _ = Double(-1000000000).toInt()
                //            _ = Double(Int.max).toInt()
                //            _ = Double(Int.min).toInt()
            }
        }
    }
    
    func testQQQ2() {
        measure {
            for _ in 1...1000 {
                _ = Double(0).toInt2()
                _ = Double(1000000000).toInt2()
                _ = Double(-1000000000).toInt2()
                //            _ = Double(Int.max).toInt2()
                //            _ = Double(Int.min).toInt2()
            }
        }
    }
    
    func testQQQ3() {
        measure {
            for _ in 1...1000 {
                _ = Double(0).toInt3()
                _ = Double(1000000000).toInt3()
                _ = Double(-1000000000).toInt3()
                //            _ = Double(Int.max).toInt3()
                //            _ = Double(Int.min).toInt3()
            }
        }
    }
    
    /// need for override
    static var coreDataStack = CoreDataStack(storeType: .memory, modelName: modelName)
    
    /// will be nil after every test
    private var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = type(of: self).coreDataStack
        coreDataStack.deleteAll()
    }
    
    override class func tearDown() {
        super.tearDown()
        coreDataStack.deleteAll()
    }
    
    private func saveManyObjects() {
        let expec = expectation(description: "expec")
        
        coreDataStack.performBackgroundTask { context in
            for i in 1...1000 {
                let event = DBEvent(managedObjectContext: context)
                event.name = "Some event \(i)"
            }
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 2)
    }
    
    private func saveOneObject() {
        let expec = expectation(description: "expec")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
    }
    
    //    func testPerformanceDeleteAll() {
    //        measure {
    //            saveOneObject()
    //            coreDataStack.deleteAll()
    //        }
    //    }
    //
    //    func testPerformanceClearAll() {
    //        measure {
    //            saveOneObject()
    //            coreDataStack.clearAll()
    //        }
    //    }
    //
    //    func testPerformanceDeleteAllMany() {
    //        measure {
    //            saveManyObjects()
    //            coreDataStack.deleteAll()
    //        }
    //    }
    //
    //    func testPerformanceClearAllMany() {
    //        measure {
    //            saveManyObjects()
    //            coreDataStack.clearAll()
    //        }
    //    }
    
}
