import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        
//        "/".utf16
//        let rr = Array(filePath.utf16)
//        if let i = rr.lastIndex(of: 47) {
//            let res = Array(rr.suffix(from: i + 1))
//            String(utf16CodeUnits: res, count: res.count)
//        }
//        print()
        
//        let filePath = "/Users/yaroslav/XcodeProjects/PerformanceTests/PerformanceTests.xcodeproj"

//        for _ in 1...10_000_000 {
//            _ = filePath.lastPathComponent()
//
//
//
////            let rr = filePath.utf8
////            if let i = rr.lastIndex(of: 47) {
////                let res = rr.suffix(from: rr.index(i, offsetBy: 1) )
////                _ = String(res)!
////            }
//
//
////            let rr = ArraySlice(filePath.utf16)
////            if let i = rr.lastIndex(of: 47) {
////                let res = rr.suffix(from: i + 1)
////                _ =  res.withUnsafeBufferPointer { String(utf16CodeUnits: $0.baseAddress!, count: res.count) }
////            }
//
//        }
        
    }
    
}

