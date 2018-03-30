//
//  Logger.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 15/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

func log(_ closure: @autoclosure () -> Any?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    Logger.shared.log(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

final public class Logger {
    
    static let shared = Logger()
    
    func configure(closure: (Logger) -> Void) {
        closure(self)
    }
    
    /// for test: Thread.sleep(forTimeInterval: 2)
    private var watchdog: Watchdog?
    open var watchMainThead = false {
        didSet {
            if !watchMainThead {
                watchdog = nil
            } else if watchdog == nil {
                watchdog = Watchdog(threshold: 0.4)
            }
        }
    }
    
    /// can be used another log method
    /// NetworkActivityLogger.shared.startLogging()
    open var logLevel: LogLevel = .simple
    open var logRequests = true
    open var logResponse = true
    
    open var showDate = false
    
    
    open var showThreadName = false
    
    
    open var showFileName = true
    
    
    open var showLineNumber = true
    
    
    open var showFunctionName = true
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    func log(_ closure: @autoclosure () -> Any?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        
        var res = ""
        
        if showDate {
            res += "\(dateFormatter.string(from: Date())) "
        }
        
        if showThreadName {
            if Thread.isMainThread {
                res += "[main] "
            } else if let threadName = Thread.current.name, !threadName.isEmpty {
                res += "[\(threadName)] "
            } else if let queueName = DispatchQueue.currentQueueLabel, !queueName.isEmpty {
                res += "[\(queueName)] "
            } else {
                res += String(format: "[%p] ", Thread.current) //"[\(Thread.current)] "
            }
        }
        
        if showFileName {
            let file = (fileName as NSString).lastPathComponent
            let line = showLineNumber ? ":\(lineNumber)" : ""
            res += "[\(file)\(line)] "
        } else if showLineNumber {
            res += "[\(lineNumber)] "
        }
        
        if showFunctionName {
            res += "\(functionName) "
        }
        
        if !res.isEmpty {
            res += "> "
        }
        
        res += String(describing: closure() ?? "nil")
        print(res)
    }
}


import RealmSwift
extension Logger {
    func printRealmFilePath() {
        let realmFilePath = Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().absoluteString
        let strLength = 7 /// "file://".characters.count
        let removedFilePath = realmFilePath?[from: strLength] ?? "Realm path is nil"
        log("Realm database is here: \(removedFilePath)")
    }
}
