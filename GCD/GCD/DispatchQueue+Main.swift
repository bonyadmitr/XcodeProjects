import Foundation

// MARK: - MainQueue
/// http://blog.benjamin-encz.de/post/main-queue-vs-main-thread/
/// https://github.com/devMEremenko/EasyCalls/blob/master/Classes/Calls/Queues/Queues.swift
public extension DispatchQueue {
    
    private static let mainQueueKey = DispatchSpecificKey<Void>()
    
    /// add to AppDelegate didFinishLaunchingWithOptions
    static func setupMainQueue() {
        DispatchQueue.main.setSpecific(key: mainQueueKey, value: ())
    }
    
    static var isMainQueue: Bool {
        return DispatchQueue.getSpecific(key: mainQueueKey) != nil
    }
    
    /**
     Being on the main thread does not guarantee to be in the main queue.
     It means, if the current queue is not main, the execution will be moved to the main queue.
     */
    static func toMain(_ handler: @escaping () -> Void) {
        if DispatchQueue.isMainQueue {
            handler()
        } else if Thread.isMainThread {
            DispatchQueue.main.async(execute: handler)
        } else {
            // Execution is not on the main queue and thread at this point.
            // The sync operation will not block any.
            // It is important to perform an operation synchronously.
            // Otherwise, it can cause a race condition.
            DispatchQueue.main.sync(execute: handler)
        }
    }
}

// MARK: - Helpers
extension DispatchQueue {
    public static func toBackground(_ handler: @escaping () -> Void) {
        DispatchQueue.global().async(execute: handler)
    }
    
    public static func delay(time: Double, handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: handler)
    }
}




/// https://gist.github.com/sgr-ksmt/4880c5df5aeec9e558622cd6d5b477cb
/// https://theswiftdev.com/2018/07/10/ultimate-grand-central-dispatch-tutorial-in-swift/
extension DispatchQueue {
    class func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
    
    class func mainSyncSafe<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try work()
        } else {
            return try DispatchQueue.main.sync(execute: work)
        }
    }
    
//    let x = DispatchQueue.main.sync {
//        return 10
//    }
    class func syncSafe<T>(_ work: () -> T) -> T {
        if Thread.isMainThread {
            return work()
        } else {
            return DispatchQueue.main.sync {
                return work()
            }
        }
    }

}


/**
 #if DEBUG
 let contextQueue = DispatchQueue.currentQueueLabelAsserted
 #endif
 
 #if DEBUG
 let contextQueue2 = DispatchQueue.currentQueueLabelAsserted
 assert(contextQueue == contextQueue2, "\(contextQueue) != \(contextQueue2)")
 #endif
 */
/// com.apple.main-thread
//assert(DispatchQueue.currentQueueLabel == DispatchQueue.main.label)
extension DispatchQueue {
    static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
    
    static var currentQueueLabelAsserted: String {
        guard let currentQueueLabel = currentQueueLabel else {
            assertionFailure("something went wrong with: \(__dispatch_queue_get_label(nil))")
            return ""
        }
        return currentQueueLabel
    }
}
