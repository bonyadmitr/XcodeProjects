import Foundation
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
