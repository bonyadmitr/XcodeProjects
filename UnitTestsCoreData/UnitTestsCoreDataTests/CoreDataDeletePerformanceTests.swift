//
//  CoreDataDeletePerformanceTests.swift
//  UnitTestsCoreDataTests
//
//  Created by Bondar Yaroslav on 12/11/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

@testable import UnitTestsCoreData
import XCTest
import CoreData

private let modelName = "UnitTestsCoreData"

/// If your test is more than 10% slower than the baseline, it'll fail
final class CoreDataDeletePerformanceTests: XCTestCase {
    
    private let coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName)
    
    override func setUp() {
        super.setUp()
        //        coreDataStack.clearAll()
        coreDataStack.deleteAll()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func saveManuObjects() {
        let expec = expectation(description: "expec")
        
        coreDataStack.performBackgroundTask { context in
            for i in 1...10000 {
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
        saveOneObject()
        measure {
            coreDataStack.deleteAll()
        }
    }
    
    func testPerformanceClearAll() {
        saveOneObject()
        measure {
            coreDataStack.clearAll()
        }
    }
    
    func testPerformanceDeleteAllMany() {
        saveManuObjects()
        measure {
            coreDataStack.deleteAll()
        }
    }
    
    func testPerformanceClearAllMany() {
        saveManuObjects()
        measure {
            coreDataStack.clearAll()
        }
    }
    
}
