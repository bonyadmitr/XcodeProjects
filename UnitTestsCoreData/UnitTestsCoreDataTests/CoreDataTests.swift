@testable import UnitTestsCoreData
import XCTest
import CoreData

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
