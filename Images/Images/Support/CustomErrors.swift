//
//  CustomErrors.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 11/10/17.
//  Copyright © 2017 LifeTech. All rights reserved.
//

import Foundation

enum CustomErrors {
    case text(String)
}

extension CustomErrors {
    
    static func unknown(lineNumber: Int = #line, fileName: String = #file, functionName: String = #function) -> CustomErrors {
        let file = (fileName as NSString).lastPathComponent
        let error = "- Error: \(CustomErrors.queueName)[\(file):\(lineNumber)] \(functionName)"
        return CustomErrors.text(error)
    }
    
    private static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
    
    private static var queueName: String {
        if Thread.isMainThread {
            return "[main] "
        } else if let threadName = Thread.current.name, !threadName.isEmpty {
            return "[\(threadName)] "
        } else if let queueName = currentQueueLabel, !queueName.isEmpty {
            return "[\(queueName)] "
        } else {
            return "[\(Thread.current)] "
        }
    }
}

extension CustomErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .text(let text):
            return text
        }
    }
}
