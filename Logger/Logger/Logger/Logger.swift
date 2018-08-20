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

// TODO: check all, create writing to file

//func logPath() -> URL {
//    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
//    return docs.appendingPathComponent("logger.txt")
//}
//
//let logger = Logger(destination: logPath())
//
//class Logger {
//    let destination: URL
//    lazy fileprivate var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = Locale.current
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        
//        return formatter
//    }()
//    lazy fileprivate var fileHandle: FileHandle? = {
//        let path = self.destination.path
//        FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
//        
//        do {
//            let fileHandle = try FileHandle(forWritingTo: self.destination)
//            print("Successfully logging to: \(path)")
//            return fileHandle
//        } catch let error as NSError {
//            print("Serious error in logging: could not open path to log file. \(error).")
//        }
//        
//        return nil
//    }()
//    
//    init(destination: URL) {
//        self.destination = destination
//    }
//    
//    deinit {
//        fileHandle?.closeFile()
//    }
//    
//    func log(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
//        let logMessage = stringRepresentation(message, function: function, file: file, line: line)
//        
//        printToConsole(logMessage)
//        printToDestination(logMessage)
//    }
//}
//
//private extension Logger {
//    func stringRepresentation(_ message: String, function: String, file: String, line: Int) -> String {
//        let dateString = dateFormatter.string(from: Date())
//        
//        let file = URL(fileURLWithPath: file).lastPathComponent 
//        return "\(dateString) [\(file):\(line)] \(function): \(message)\n"
//    }
//    
//    func printToConsole(_ logMessage: String) {
//        print(logMessage)
//    }
//    
//    func printToDestination(_ logMessage: String) {
//        if let data = logMessage.data(using: String.Encoding.utf8) {
//            fileHandle?.write(data)
//        } else {
//            print("Serious error in logging: could not encode logged string into data.")
//        }
//    }
//}
