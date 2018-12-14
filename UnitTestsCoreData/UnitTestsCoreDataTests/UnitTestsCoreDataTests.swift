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
private let eventName = "Some event"

/// one method of NSFetchedResultsControllerDelegate need for NSFetchedResultsController updates
final class FetchDelegate: NSObject, NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}

class BaseCoreDataTests: XCTestCase {
    /// need for override
    static var coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName)
    
    /// will be nil after every test
    var coreDataStack: CoreDataStack!
    
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
    
    func createEvent() {
        let expec = expectation(description: "expec")
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = eventName
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
    }
}

class UnitTestsCoreDataTests: BaseCoreDataTests {
    
    override class func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .sqlite, modelName: modelName, oldApi: false)
    }
    
    private let fetchDelegate = FetchDelegate()
    
    private func fetchedResultsController() -> NSFetchedResultsController<DBEvent> {
        let fetchRequest: NSFetchRequest = DBEvent.fetchRequest()
        let sortDescriptor1 = NSSortDescriptor(key: #keyPath(DBEvent.name), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        let context = coreDataStack.viewContext
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func testFetchControllerSave() {
        let fetchController = fetchedResultsController()
        fetchController.delegate = fetchDelegate
        try? fetchController.performFetch()
        
        createEvent()
        let events = fetchController.fetchedObjects
        
        XCTAssertEqual(events?.count, 1)
        XCTAssert(events?.first?.name == eventName)
    }
    
    func testFetchControllerDelete() {
        let fetchController = fetchedResultsController()
        fetchController.delegate = fetchDelegate
        try? fetchController.performFetch()
        
        createEvent()
        coreDataStack.deleteAll()
        //coreDataStack.clearAll()
        
        let expec = expectation(description: "expec")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expec.fulfill()
        }
        wait(for: [expec], timeout: 1)
        
        let events = fetchController.fetchedObjects
        
        XCTAssertEqual(events?.count, 0)
    }
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

class CoreDataMemoryTests: BaseCoreDataTests {

    override class func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(storeType: .memory, modelName: modelName)
    }
    
    func testCoreDataSave() {
        createEvent()
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 1)
        XCTAssert(events?.first?.name == eventName)
        
        /// Called when test method ends.
        addTeardownBlock {
            print("--- testCoreDataSave ended")
        }
    }
    
    func testClearAll() {
        createEvent()
        
        coreDataStack.clearAll()
//        coreDataStack.deleteAll()
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 0)
    }
    
    func testClearAllAndSave() {
        createEvent()
        
        coreDataStack.clearAll()
        
        let expec = expectation(description: "expec")
        coreDataStack.performBackgroundTask { context in
            let event = DBEvent(managedObjectContext: context)
            event.name = "Some event 2"
            context.saveSyncUnsafe()
            expec.fulfill()
        }
        wait(for: [expec], timeout: 1)
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 1)
        XCTAssert(events?.first?.name == "Some event 2")
    }
    
    /// working ONLY with NSSQLiteStoreType
    func testDeleteAll() {
        createEvent()
        
        let expec = expectation(description: "expec")
        coreDataStack.deleteAll { status in
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 1)
        
        let fetchRequest: NSFetchRequest<DBEvent> = DBEvent.fetchRequest()
        let events = try? coreDataStack.viewContext.fetch(fetchRequest)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 0)
    }
}
