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

/// If your test is more than 10% slower than the baseline, it'll fail
class CoreDataDeleteMemoryPerformanceTests: XCTestCase {
    
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
    
    func testPerformanceDeleteAll() {
        measure {
            saveOneObject()
            coreDataStack.deleteAll()
        }
    }
    
    func testPerformanceClearAll() {
        measure {
            saveOneObject()
            coreDataStack.clearAll()
        }
    }
    
    func testPerformanceDeleteAllMany() {
        measure {
            saveManyObjects()
            coreDataStack.deleteAll()
        }
    }
    
    func testPerformanceClearAllMany() {
        measure {
            saveManyObjects()
            coreDataStack.clearAll()
        }
    }
    
}
