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
