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
        // TODO: en_US vs en_US_POSIX
        // https://developer.apple.com/library/archive/qa/qa1480/_index.html
        // https://stackoverflow.com/questions/6613110/what-is-the-best-way-to-deal-with-the-nsdateformatter-locale-feechur
        // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW7
        
        // TODO: check https://developer.apple.com/documentation/foundation/dateformatter
        

        // TODO: setLocalizedDateFormatFromTemplate
        // https://developer.apple.com/documentation/foundation/dateformatter
        // https://developer.apple.com/documentation/foundation/nsdateformatter/1417087-setlocalizeddateformatfromtempla
        //DateFormatter().setLocalizedDateFormatFromTemplate("")
        let locale = Locale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        let is12hoursDeviceFormat = dateFormat.last == "a"//safe: dateFormat.contains("a")
        print("12 hours?", is12hoursDeviceFormat)
    }


}

