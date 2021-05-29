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
        
        
        
        
//        measure {
//            for _ in 1...1_000_000 {
//                _ = (filePath as NSString).lastPathComponent
//            }
//        }

//        measure {
//            for _ in 1...1_000_000 {
//                //_ = filePath.lastPathComponent()
//            }
//        }
//        for _ in 1...1_000_000 {
//            _ = filePath.lastPathComponent()
//        }
        
//        let filePath = "/Users/yaroslav/XcodeProjects/PerformanceTests/PerformanceTests.xcodeproj///"
//        print(filePath.lastPathComponent())
//        print()
        
        
        
        
//        var q = Food.artichoke
//        func some() {
//            q = .broccoli
//        }
//        q = .beef
//        some()
//
//        measure {
//            for _ in 1...1_000_000_000 {
//                _ = q.isVegetable()
//            }
//        }
        
        
    }
    
}

//[9.19681042432785e-08, 2.9045622795820236e-08, 2.898741513490677e-08, 2.3981556296348572e-08, 2.3981556296348572e-08, 2.403976395726204e-08, 2.3981556296348572e-08, 2.403976395726204e-08, 2.3981556296348572e-08, 2.2992026060819626e-08]
//average: 3.169989213347435e-08

//[3.899913281202316e-08, 2.898741513490677e-08, 2.2992026060819626e-08, 2.200249582529068e-08, 2.2992026060819626e-08, 2.0954757928848267e-08, 2.200249582529068e-08, 2.1944288164377213e-08, 2.2992026060819626e-08, 2.2992026060819626e-08]
//average: 2.468586899340153e-08

    }
    
}

