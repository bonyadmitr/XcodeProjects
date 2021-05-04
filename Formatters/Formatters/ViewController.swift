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
        
        /// j = This is a special-purpose symbol. It must not occur in pattern or skeleton data. Instead, it is reserved for use in skeletons passed to APIs doing flexible date pattern generation. In such a context, it requests the preferred hour format for the locale (h, H, K, or k), as determined by whether h, H, K, or k is used in the standard short time format for the locale. In the implementation of such an API, 'j' must be replaced by h, H, K, or k before beginning a match against availableFormats data. Note that use of 'j' in a skeleton passed to an API is the only way to have a skeleton request a locale's preferred time cycle type (12-hour or 24-hour).
        /// http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Field_Symbol_Table
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale: locale) ?? "HH"
//        let is12hoursDeviceFormat = dateFormat.last == "a"//safe: dateFormat.contains("a")
//        print("12 hours?", is12hoursDeviceFormat)
        let is24hoursDeviceFormat = dateFormat.first == "H"
        print("24 hours?", is24hoursDeviceFormat)
        print()
        //DateFormatter.dateFormat(fromTemplate: "j", options:0, locale: Locale(identifier: "en_BY"))!.last == "a"
        
        
        //DateFormatter.dateFormat(fromTemplate: "MM.dd.yyyy HH:mm:ss", options:0, locale: Locale(identifier: "tr"))
        let dateFormat2 = DateFormatter.dateFormat(fromTemplate: "MM.dd.yyyy HH:mm:ss", options:0, locale: locale) ?? "HH"
        // ru 24: dd.MM.yyyy, HH:mm:ss
        // ru 12: dd.MM.yyyy, h:mm:ss a
        print(dateFormat2)
        
        let df = DateFormatter()
        df.dateFormat = dateFormat2
        print( df.string(from: Date()) )
        
        print()
        
        
    }


}

