@testable import UnitTestsCoreData
import XCTest
import CoreData

/// one method of NSFetchedResultsControllerDelegate need for NSFetchedResultsController updates
final class FetchDelegate: NSObject, NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}

class FetchedResultsControllerTests: BaseCoreDataTests {
    
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
