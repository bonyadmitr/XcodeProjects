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

extension String.StringInterpolation {
    
    mutating func appendInterpolation(_ value: CustomStringConvertible?, or: @autoclosure () -> CustomStringConvertible = "nil") {
        appendInterpolation(value ?? or())
    }
}
