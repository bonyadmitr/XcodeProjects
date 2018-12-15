@testable import UnitTestsCoreData
import XCTest

let modelName = "UnitTestsCoreData"
let eventName = "Some event"

/// https://developer.apple.com/documentation/xctest/xctestcase/understanding_setup_and_teardown_for_test_methods
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
