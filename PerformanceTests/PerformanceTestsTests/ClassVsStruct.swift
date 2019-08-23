import XCTest
//@testable import PerformanceTests

private struct PhonebookEntry {
    let name: String
    let number: [Int]
    
    init(name: String, number: [Int]) {
        self.name = name
        self.number = number
    }
    
    init(i: Int) {
        self.init(name: "\(i)", number: [i])
    }
}

private class PhonebookEntryClass {
    let name: String
    let number: [Int]
    
    init(name: String, number: [Int]) {
        self.name = name
        self.number = number
    }
    
    convenience init(i: Int) {
        self.init(name: "\(i)", number: [i])
    }
}

/// do we need add "*.xcbaseline" to .gitignore?
/// if no, lets use time baselines for iPhone 6 Plus 12.2.
/// but it will changed for every new xcode/device model/device version

/// !!! don't create XCTestCase subclass private!!! Otherwise tests rhombus<✓> will be ignored
/// !!! Edit scheme... - Test (Left side bar) - Info (Top tab/segment) - Build Configuration - (set) Release
final class ClassVsStructTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStructAppend() {
        self.measure {
            var a = [PhonebookEntry]()
            for i in 1...1000000 {
                let entry = PhonebookEntry(i: i)
                a.append(entry)
            }
        }
    }
    
    func testStructAppend2() {
        self.measure {
            var array = [PhonebookEntry]()
            (1...1000000).forEach { array.append(PhonebookEntry(i: $0)) }
        }
    }
    
    func testClassAppend() {
        self.measure {
            var a = [PhonebookEntryClass]()
            for i in 1...1000000 {
                let entry = PhonebookEntryClass(i: i)
                a.append(entry)
            }
        }
    }
    
    func testStructMap() {
        self.measure {
            _ = (1...1000000).map { PhonebookEntry(i: $0) }
        }
    }
    
    func testClassMap() {
        self.measure {
            _ = (1...1000000).map { PhonebookEntryClass(i: $0) }
        }
    }
    
}
