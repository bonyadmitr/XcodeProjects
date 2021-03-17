//
//  ViewController.swift
//  Debugger
//
//  Created by Yaroslav Bondr on 08.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
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
