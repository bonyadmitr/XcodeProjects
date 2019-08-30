import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testDispatchAssert()
        testOptionalAssert()
        testAssert()
        
        view.backgroundColor = .lightGray
        print("- viewDidLoad")
    }
    
    private func testDispatchAssert() {
        
        if #available(iOS 10.0, *) {
            dispatchAssert(condition: .onQueue(.main))
        }
        
        assertMainQueue()
        assertMainThread()
        
        DispatchQueue.global().async {
            assertBackgroundQueue()
            assertBackgroundThread()
        }
    }
    
    private func testOptionalAssert() {
        let text: String? = "some"
        
        if let unwrapedText2 = text {
            print(unwrapedText2)
        } else {
            assertionFailure("shouldn't be executed")
        }
        
        guard let unwrapedText2 = text else {
            assertionFailure("shouldn't be executed")
            return
        }
        print(unwrapedText2)
        
        let unwrapedText = text.assert(or: "")
        print(unwrapedText)
        
        text.assertExecute { print($0) }
    }
    
    private func testAssert() {
        var array = [0, 1]
        array.append(2)
        assert(array.count == 3, "must contain 3 items")
    }
}
