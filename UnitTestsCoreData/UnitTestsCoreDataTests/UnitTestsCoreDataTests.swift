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

final class UnitTestsCoreDataTests: XCTestCase {

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
    }
    
    func testClearAllSQLite() {
        let expec = expectation(description: "expec1")
        
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        coreDataStack.clearAll()
        
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
        let coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName)
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
