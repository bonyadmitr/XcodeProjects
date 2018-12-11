//
//  UnitTestsCoreDataTests.swift
//  UnitTestsCoreDataTests
//
//  Created by Bondar Yaroslav on 11/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

@testable import UnitTestsCoreData
import XCTest
import CoreData

private let modelName = "UnitTestsCoreData"

class UnitTestsCoreDataTests: XCTestCase {
}

/// https://developer.apple.com/documentation/xctest/xctestcase/understanding_setup_and_teardown_for_test_methods

final class CoreDataOldApiSQLTests: CoreDataMemoryTests {
    override class func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName, oldApi: true)
    }
}

final class CoreDataOldApiMemoryTests: CoreDataMemoryTests {
    override class func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .memory, modelName: modelName, oldApi: true)
    }
}

final class CoreDataSQLTests: CoreDataMemoryTests {
    override class func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName)
    }
}

class CoreDataMemoryTests: XCTestCase {
    
    /// need for override
    static var coreDataStack = CoreDataStack(storeType: .memory, modelName: modelName)
    
    /// will be nil after every test
    private var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = type(of: self).coreDataStack
        coreDataStack.deleteAll()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override class func tearDown() {
        super.tearDown()
        coreDataStack.deleteAll()
    }

    func testCoreDataSave() {
        let expec = expectation(description: "CoreDataStack")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events!.count, 1)
        XCTAssert(events?.first?.name == "Some event")
        
        /// Called when test method ends.
        addTeardownBlock {
            print("--- testCoreDataSave ended")
        }
    }
    
    func testClearAll() {
        let expec = expectation(description: "expec1")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        coreDataStack.clearAll()
//        coreDataStack.deleteAll()
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 0)
    }
    
    func testClearAllAndSave() {
        let expec = expectation(description: "expec")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        coreDataStack.clearAll()
        let expec2 = expectation(description: "expec2")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event 2"
            context.saveSyncUnsafe()
            expec2.fulfill()
        }
        
        wait(for: [expec2], timeout: 1)
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events!.count, 1)
        XCTAssert(events?.first?.name == "Some event 2")
    }

//        let expec = expectation(description: "1")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            expec.fulfill()
//        }
//        waitForExpectations(timeout: 2, handler: nil)
    
    /// working ONLY with NSSQLiteStoreType
    func testDeleteAll() {
//        let coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName)
        let expec = expectation(description: "expec")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        let expec2 = expectation(description: "expec2")
        coreDataStack.deleteAll { status in
            expec2.fulfill()
        }
        
        wait(for: [expec2], timeout: 1)
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 0)
    }
}
