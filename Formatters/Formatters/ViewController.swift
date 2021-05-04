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
        print("viewDidLoad")
        
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
        
        // TODO: 12-hour mode vs 24 hour mode
        // TODO: formats: h + K vs H + k
        /// http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Field_Symbol_Table
        /// https://stackoverflow.com/a/14276208/5893286
        /// https://stackoverflow.com/a/33758481/5893286
        
        
        // TODO: Locale(identifier: "en_BY") == Locale.current // false
        // in 24 hours style
        
        
        //ru - "HH"
        //en - "h a"
        //en_RU - "HH"
        //"en_US" - "h a"
        //"en_US_POSIX" - "h a"
        let locale = Locale.current
        //let locale = Locale(identifier: "en_US")
        
        
        // TODO: doc
        /// difference between the date formats for British and American English:
        /// https://developer.apple.com/documentation/foundation/dateformatter/1408112-dateformat
//        let usLocale = Locale(identifier: "en_US")
//        let gbLocale = Locale(identifier: "en_GB")
//        let template = "yMMMMd"
//
//        let usDateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: usLocale)!
//        // Date format for English (United States): "MMMM d, y"
//        let gbDateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: gbLocale)!
//        // Date format for English (United Kingdom): "d MMMM y"
    }


}

