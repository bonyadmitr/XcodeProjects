//
//  DispatchQueue+Main.swift
//  DispatchQueue+Main
//
//  Created by Bondar Yaroslav on 3/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

public typealias VoidHandler = () -> Void

// MARK: - MainQueue
/// http://blog.benjamin-encz.de/post/main-queue-vs-main-thread/
/// https://github.com/devMEremenko/EasyCalls/blob/master/Classes/Calls/Queues/Queues.swift
public extension DispatchQueue {
    
    private static let mainQueueKey = DispatchSpecificKey<String>()
    private static let mainQueueValue = "DispatchQueue.mainQueueValue"
    
    /// add to AppDelegate didFinishLaunchingWithOptions
    static func setupMainQueue() {
        DispatchQueue.main.setSpecific(key: mainQueueKey, value: mainQueueValue)
    }
    
    static var isMainQueue: Bool {
        return DispatchQueue.getSpecific(key: mainQueueKey) != nil
    }
    
    /**
     Being on the main thread does not guarantee to be in the main queue.
     It means, if the current queue is not main, the execution will be moved to the main queue.
     */
    public static func toMain(_ handler: @escaping VoidHandler) {
//        once { 
//            setupMainQueue()
//        }
        if DispatchQueue.isMainQueue {
            handler()
        } else if Thread.isMainThread {
            DispatchQueue.main.async {
                handler()
            }
        } else {
            // Execution is not on the main queue and thread at this point.
            // The sync operation will not block any.
            // It is important to perform an operation synchronously.
            // Otherwise, it can cause a race condition.
            DispatchQueue.main.sync {
                handler()
            }
        }
    }
}

// MARK: - Helpers
extension DispatchQueue {
    public static func toBackground(_ handler: @escaping VoidHandler) {
        DispatchQueue.global().async(execute: handler)
    }
    
    public static func delay(time: Double, handler: @escaping VoidHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: handler)
    }
}

/// https://stackoverflow.com/a/39983813/5893286
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block: VoidHandler) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block: VoidHandler) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

