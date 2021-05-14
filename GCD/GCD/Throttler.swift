import Foundation

// usage
//Throttler.go {
//    print("go! > \(1)")
//}
//Throttler.go {
//    print("go! > \(2)")
//}
//
//Throttler.go(id: "3") {
//    print("go! > \(3)")
//}
//Throttler.go(id: "3") {
//    print("go! > \(3)")
//}
//
//for i in 1...1000 {
//    Throttler.go {
//        print("go! > \(i)")
//    }
//}
/// inspired https://github.com/boraseoksoon/Throttler
/// can be created DispatchQueue extension
enum Throttler {
    
    static private var workItems: [String: DispatchWorkItem] = [:]
    
    /// also can be used `identifier: String = "\(Thread.callStackSymbols)",` but it is too long
    //    static func go(delay: TimeInterval = 0.25,
    //                   queue: DispatchQueue = .main,
    //                   file: String = #file,
    //                   line: Int = #line,
    //                   column: Int = #column,
    //                   action: @escaping () -> Void)
    //     {
    //        let id = "\(file)_\(line)_\(column)"
    static func go(delay: TimeInterval = 0.25,
                   queue: DispatchQueue = .main,
                   id: String = Thread.callStackSymbols[1], //need more tests for [1]
                   action: @escaping () -> Void)
    {
        if let workItem = workItems[id] {
            workItem.cancel()
        }
        let workItem = DispatchWorkItem(block: action)
        workItems[id] = workItem
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
    
    /// use on logout, memory warning
    static func clear() {
        workItems = [:]
    }
}
