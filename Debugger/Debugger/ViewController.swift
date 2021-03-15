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
