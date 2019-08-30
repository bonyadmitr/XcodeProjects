import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testDispatchAssert()
        testOptionalAssert()
        
        
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
            assertionFailure()
        }
        
        guard let unwrapedText2 = text else {
            assertionFailure()
            return
        }
        print(unwrapedText2)
        
        let unwrapedText = text.assert(or: "")
        print(unwrapedText)
        
        text.assertExecute { print($0) }
    }
}
