//
//  Logger.swift
//  Background
//
//  Created by Bondar Yaroslav on 7/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//
import XCGLogger

enum Device {
    static func documentsFolderUrl(withComponent: String) -> URL? {
        let documentsUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentsUrls.last?.appendingPathComponent(withComponent)
    }
}

enum LoggerConstants {
    static let identifier = "advancedLogger"
    static let fileName = "app.log"
    static let logUrl = Device.documentsFolderUrl(withComponent: fileName)
    static let fileAppendMarker = "-- Relaunched App --"
    static let fileDestinationIdentifier = "advancedLogger.fileDestination"
    static let maxFileSize: UInt64 = 1024 * 1024 * 10 /// 10 mb
    static let maxTimeInterval: TimeInterval = 24 * 60 * 60 * 10 /// 10 days
}

// the global reference to logging mechanism to be available in all files
let log: XCGLogger = {
    
    let log = XCGLogger(identifier: LoggerConstants.identifier, includeDefaultDestinations: false)
    
    if let logUrl = LoggerConstants.logUrl {
        
        let fileDestination = AutoRotatingFileDestination(owner: log,
                                                          writeToFile: logUrl,
                                                          identifier: LoggerConstants.fileDestinationIdentifier,
                                                          shouldAppend: true,
                                                          appendMarker: LoggerConstants.fileAppendMarker,
                                                          attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
                                                          maxFileSize: LoggerConstants.maxFileSize,
                                                          maxTimeInterval: LoggerConstants.maxTimeInterval,
                                                          archiveSuffixDateFormatter: nil)
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        fileDestination.logQueue = XCGLogger.logQueue
        
        log.add(destination: fileDestination)
    }
    
    log.logAppDetails()
    
    return log
}()

func debugLog(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    
    log.logln(.debug, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo, closure: closure)
    
    let resultString = String(describing: closure() ?? "nil") 
    print(resultString)
}
