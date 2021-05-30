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


func measure(block: () -> Void) {
    var results = [CFTimeInterval]()
    let times = 10
    for _ in 1...times {
        let startTime = CACurrentMediaTime()
        block()
        let endTime = CACurrentMediaTime()
        results.append(endTime - startTime)
    }
    let average = results.reduce(0, +) / Double(times)
    print(results)
    print("average: \(average)")
}

//extension String {
//
//    //    “/tmp/scratch.tiff”     “scratch.tiff”
//    //    “/tmp/scratch”          “scratch”
//    //    “/tmp/”                 “tmp”
//    //    “scratch///”            “scratch”
//    //    “/”                     “/”
//    func lastPathComponent() -> String {
//        if let i = lastIndex(where: { $0 == "/" }) {
//            let nextI = index(i, offsetBy: 1)
//            let result = self[nextI...]
//            if result.isEmpty {
//                return String(self[..<i]).lastPathComponent()
//            } else {
//                return String(result)
//            }
//
//        } else {
//            return "/"
//            //return self
//        }
//
//    }
//
//}


extension String {
    
    private static let pathChar = "/".utf8.first ?? 47
    
    //    “/tmp/scratch.tiff”     “scratch.tiff”
    //    “/tmp/scratch”          “scratch”
    //    “/tmp/”                 “tmp”
    //    “scratch///”            “scratch”
    //    “/”                     “/”
    func lastPathComponent() -> String {
        
        let utf = utf8
        
        func qq(s: Substring.UTF8View) -> String {
            if let i = s.lastIndex(of: Self.pathChar) {
                let nextI = s.index(i, offsetBy: 1)
                let suffix = s.suffix(from: nextI)
                
                if suffix.isEmpty {
                    return qq(s: s[..<i])
                } else {
                    return String(suffix) ?? "/"
                }
            } else {
                return "/"
            }
        }
        
        if let i = utf.lastIndex(of: Self.pathChar) {
            let nextI = utf.index(i, offsetBy: 1)
            let suffix = utf.suffix(from: nextI)
            
            if suffix.isEmpty {
                return qq(s: utf[..<i])
            } else {
                return String(suffix) ?? "/"
            }
        }
        
        
        
//        let rr = utf8
//        if let i = rr.lastIndex(of: 47) {
//            let res = rr.suffix(from: rr.index(i, offsetBy: 1) )
//            return String(res)!
//        }
        
        
        /// https://stackoverflow.com/a/40536964/5893286
        //        let rr = ArraySlice(utf16)
        //        if let i = rr.lastIndex(of: 47) {
        //            let res = rr.suffix(from: i + 1)
        //            return res.withUnsafeBufferPointer { String(utf16CodeUnits: $0.baseAddress!, count: res.count) }
        //            //return String(utf16CodeUnits: res, count: res.count)
        //        }
        
        return "/"
        
        
        //        if let i = lastIndex(of: "/") {
        //
        //            //return String(self[index(i, offsetBy: 1)...])
        //
        //            let nextI = index(i, offsetBy: 1)
        //            let result = suffix(from: nextI)//self[nextI...]
        //            if result.isEmpty {
        //                return String(self[..<i]).lastPathComponent()
        //            } else {
        //                return String(result)
        //            }
        //
        //        } else {
        //            return "/"
        //            //return self
        //        }
        
    }
    
}

enum Food {
    case beef
    case broccoli
    case chicken
    case greenPepper
    case lettuce
    case onion
    case redPepper
    case spinach
    case artichoke
    case cabbage
    case celery
    case kale
    case radish
    case squash
    case parsley
    case yellowPepper
    
    func isVegetable() -> Bool {
        return self == .broccoli ||
            self == .greenPepper ||
            self == .lettuce ||
            self == .onion ||
            self == .redPepper ||
            self == .spinach ||
            self == .artichoke ||
            self == .cabbage ||
            self == .celery ||
            self == .kale ||
            self == .radish ||
            self == .squash ||
            self == .parsley ||
            self == .yellowPepper
    }
    
    func isVegetableSwitch() -> Bool {
        switch self {
        case .broccoli, .greenPepper, .lettuce, .onion, .redPepper, .spinach, .artichoke, .cabbage, .celery, .kale, .radish, .squash, .parsley, .yellowPepper:
            return true
        case .beef, .chicken:
            return false
        }
    }
    
}
