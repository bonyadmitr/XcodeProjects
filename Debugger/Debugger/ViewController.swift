//
//  ViewController.swift
//  Debugger
//
//  Created by Yaroslav Bondr on 08.02.2021.
//

import UIKit

 NSSetUncaughtExceptionHandler { (exception) in
     print(exception)
     exception.callStackSymbols.forEach{ print($0)}
     print()
 }
 /// to test
 NSArray().object(at: 1)
 NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil).raise()
 
 // TODO: check
 https://github.com/woshiccm/RCBacktrace
 https://www.raywenderlich.com/6334294-my-app-crashed-now-what

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        DispatchQueue.global().async {
//            CallStackParser.printStack()
//        }
        CallStackParser.printStack()
//        someFunc()
        
        
//        print("- call stack trace:")
//        Thread.callStackSymbols
//            .compactMap{ CallStackParser.parseStack($0) }
//            .forEach { Swift.print($0) }
//        Thread.callStackSymbols
//            .compactMap{ CallStackParser.classAndMethodForStackSymbol($0) }
//            .forEach { print("\($0.class):\($0.function)") }
//        print("-")
        
    //    Swift.print(Thread.callStackSymbols)
        /// better formatting
//        Thread.callStackSymbols.forEach{Swift.print($0)}
        
        
//        print("started")
//        print("started", 123, 123)
    }

    private func someFunc() {
        DispatchQueue.global().async { [weak self] in
            DispatchQueue.main.async {
                self?.www()
            }
        }
    }

    private func www() {
        CallStackParser.printStack()
    }
    
}



/// https://stackoverflow.com/a/59576554/5893286
/// https://gist.github.com/zeero/d04279bd17d0555a3ceecb2376834204
func print(_ items: String...,
                  separator: String = " ",
                  terminator: String = "\n",
                  filePath: String = #file,
                  functionName: String = #function,
                  lineNumber: UInt = #line)
{
    #if DEBUG
    /// (filePath as NSString) == URL(fileURLWithPath: filePath) in this using
    let output = items.joined(separator: separator)
    let fileName = (((filePath as NSString).lastPathComponent) as NSString).deletingPathExtension // removes ".swift"
    
//    let pretty = "\((fileName as NSString).lastPathComponent) [#\(lineNumber)] \(functionName)\n\t-> \(output)"
//    let pretty = "- \((fileName as NSString).lastPathComponent):\(lineNumber)\n\t- "
//    let pretty = "- \(output) :\(fileName):\(lineNumber):\(functionName)"
//    let pretty = "- \(fileName):\(lineNumber):\(functionName): \(output)"
//    let pretty = "- \(fileName):\(lineNumber): \(output)"
//    let pretty = "- \(fileName):\(lineNumber)| \(output)"
//    let pretty = "ℹ️ [\(fileName):\(lineNumber)] \(output)"
//    let pretty = "[\(fileName):\(lineNumber):\(functionName)] \(output)"
    let pretty = "[\(fileName):\(lineNumber)] \(output)"

    Swift.print(pretty, terminator: terminator)
    #endif
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    if items.isEmpty {
        Swift.print()
        return
    }
    
    let output = items.map { "\($0)" }.joined(separator: separator)
    let pretty: String
    
    if let thisMethodInfo = CallStackParser.getCallingClassAndMethodInScope(includeImmediateParentClass: true) {
        pretty = "[\(thisMethodInfo.class):\(thisMethodInfo.function)] \(output)"
    } else {
        pretty = "- \(output)"
    }
    
    Swift.print(pretty, terminator: terminator)
    #endif
}




/**
 let x: Int? = 1
 let y: Int! = nil
 print("x: \(x)") // x: 1
 print("y: \(y, or: "nil")") // y: nil + will not crash
 print("y: \(y ?? "nil")") // now you can use `?? ""`
 */
extension String.StringInterpolation {
    
    mutating func appendInterpolation(_ value: CustomStringConvertible?, or: @autoclosure () -> CustomStringConvertible = "nil") {
        appendInterpolation(value ?? or())
    }
    /// old
//    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?, or: @autoclosure () -> CustomStringConvertible) {
//        appendInterpolation(value ?? or())
//    }
    /// other
//    mutating func appendInterpolation<T>(_ value: T?, or: @autoclosure () -> T) {
//        appendInterpolation(value ?? or())
//    }
    
//    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
//        appendInterpolation(value, or: "nil")
//    }
//    mutating func appendInterpolation(_ value: CustomStringConvertible?) {
//        appendInterpolation(value, or: "nil")
//    }
}
