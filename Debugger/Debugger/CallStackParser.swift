//
//  CallStackParser.swift
//  Debugger
//
//  Created by Yaroslav Bondr on 08.02.2021.
//

import Foundation
final class CallStackParser {
    
    private static func parseComponents(_ components: [String]) -> String? {
//        print(components)
        guard
            components.count >= 4,
            let fullFunc = try? parseMangledSwiftSymbol(components[3])
                .description
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
        else {
            return nil
        }
        let fullFuncComponents = fullFunc.split(separator: " ").map { String($0) }
        

        // TODO: check for "class"
        guard
            let projectName = Bundle.main.infoDictionary?["CFBundleName"] as? String,
            let projectFunc = fullFuncComponents.first (where: { $0.hasPrefix(projectName) })
        else {
            return fullFunc
        }
        
//        let w: String
//        if packageClassAndMethod1.first == "static" || packageClassAndMethod1.first == "class" {
//            w = packageClassAndMethod1[1]
//        } else {
//            w = packageClassAndMethod1[0]
//        }
            
        let projectFuncComponents = projectFunc.split(separator: ".")
        let componentsNumber = projectFuncComponents.count
        if componentsNumber >= 2 {
            let method = CallStackParser.cleanMethod(method: String(projectFuncComponents[componentsNumber - 1]))
            let className = String(projectFuncComponents[componentsNumber - 2])
            return "\(className):\(method)"
        } else {
            return projectFunc
        }
    }
    
    /**
     Analyses the 'NSThread.callStackSymbols()' and returns the calling class and method in the scope of the caller.
     
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func getCallingClassAndMethodInScope(includeImmediateParentClass: Bool = false) -> (class: String, function: String)? {
        let stackSymbols = Thread.callStackSymbols
        if (stackSymbols.count >= 3) {
            return CallStackParser.classAndMethodForStackSymbol(stackSymbols[2], includeImmediateParentClass: includeImmediateParentClass)
        }
        return nil
    }
    
    /**
     Analyses the 'NSThread.callStackSymbols()' and returns the current class and method in the scope of the caller.
     
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func getThisClassAndMethodInScope(includeImmediateParentClass: Bool = false) -> (class: String, function: String)? {
        let stackSymbols = Thread.callStackSymbols
        if (stackSymbols.count >= 2) {
            return CallStackParser.classAndMethodForStackSymbol(stackSymbols[1], includeImmediateParentClass: includeImmediateParentClass)
        }
        return nil
    }
    
}


//
//  String+Extensions.swift
//
//  https://stackoverflow.com/a/24144365
//  Copyright © 2018 aleclarson. All rights reserved.
//
import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
}

extension Substring {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
}
