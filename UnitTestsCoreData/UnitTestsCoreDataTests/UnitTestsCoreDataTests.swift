//
//  UnitTestsCoreDataTests.swift
//  UnitTestsCoreDataTests
//
//  Created by Bondar Yaroslav on 11/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import XCTest
@testable import UnitTestsCoreData
import CoreData

class UnitTestsCoreDataTests: XCTestCase {

    override func setUp() {
        let coreDataStack = CoreDataStack(storeType: .sqlite, modelName: "UnitTestsCoreData")
        coreDataStack.container.clearAll()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoreDataSave() {
        let coreDataStack = CoreDataStack(storeType: .memory, modelName: "UnitTestsCoreData")
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
    }
    
    func testClearAll() {
        let coreDataStack = CoreDataStack(storeType: .memory, modelName: "UnitTestsCoreData")
        let expec = expectation(description: "CoreDataStack")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        coreDataStack.container.clearAll()
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 0)
    }
    
    /// working ONLY with NSSQLiteStoreType
    func testClearAll2() {
        let coreDataStack = CoreDataStack(storeType: .sqlite, modelName: "UnitTestsCoreData")
        let expec = expectation(description: "CoreDataStack")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        let expec2 = expectation(description: "CoreDataStack2")
        coreDataStack.deleteAll { status in
            expec2.fulfill()
        }
        
        wait(for: [expec2], timeout: 1)
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 0)
    }
    
    func testClearAllAndSave() {
        let coreDataStack = CoreDataStack(storeType: .memory, modelName: "UnitTestsCoreData")
        let expec = expectation(description: "CoreDataStack")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        coreDataStack.container.clearAll()
        let expec2 = expectation(description: "CoreDataStack2")
        
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
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
