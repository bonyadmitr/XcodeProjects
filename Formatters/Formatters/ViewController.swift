//
//  ViewController.swift
//  Formatters
//
//  Created by Yaroslav Bondar on 29.04.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DatesAndTimes/DatesAndTimes.html
        // Data Formatting https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DataFormatting/DataFormatting.html
        // Date Formatters https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
        let locale = Locale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        let is12hoursDeviceFormat = dateFormat.last == "a"//safe: dateFormat.contains("a")
        print("12 hours?", is12hoursDeviceFormat)
    }


}

