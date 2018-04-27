//
//  TelephonyManager.swift
//  CountryCode
//
//  Created by Bondar Yaroslav on 26/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

import Foundation

///#if os(iOS)
import CoreTelephony

final class TelephonyManager {
    
    private lazy var networkInfo = CTTelephonyNetworkInfo()
    private lazy var carrier: CTCarrier? = networkInfo.subscriberCellularProvider
    
    var networkCode: String? {
        return carrier?.mobileNetworkCode
    }
    
    var countryCode: String? {
        return carrier?.mobileCountryCode
    }
    
    var isoCountryCode: String? {
        return carrier?.isoCountryCode
    }
    
    //    func operatorName() -> String? {
    //        guard
    //            let carrier = carrier,
    //            let networkCode = carrier.mobileNetworkCode,
    //            let countryCode = carrier.mobileCountryCode
    //        else {
    //            return nil
    //        }
    //
    //        if countryCode == "286" {
    //            switch networkCode {
    //            case "01" :
    //                return "TURKCELL"
    //            case "02" :
    //                return "VODAFONE"
    //            case "03" :
    //                return "AVEA"
    //            default:
    //                return nil
    //            }
    //        } else {
    //            return String(format: "%@-%@", countryCode, networkCode)
    //        }
    //    }
}


/// Pickers
/// https://github.com/NikKovIos/NKVPhonePicker
/// https://github.com/kizitonwose/CountryPickerView


/// Manager + Images
/// https://github.com/tinrobots/CountryKit/blob/master/Sources/CountryKit.swift

/// JSON
/// https://gist.github.com/Goles/3196253

final class LanguageManager {
    
    /// singleton
    static let shared = LanguageManager()
    
    /// array of available languages
    public var availableLanguages: [String] {
        return ["en", "he", "ru"]
        /// get from AppleLanguages
        //return UserDefaults.standard.array(forKey: "AppleLanguages") as! [String]
        //var availableLanguages = Bundle.main.localizations
        //if let indexOfBase = availableLanguages.index(of: "Base") {
        //    availableLanguages.remove(at: indexOfBase)
        //}
        //return availableLanguages
    }
    
    /// first language from Bundle.main.preferredLocalizations
    //public var defaultLanguage: String {
    //    guard let preferredLanguage = Bundle.main.preferredLocalizations.first,
    //        availableLanguages.contains(preferredLanguage)
    //        else { return devLanguage }
    //    return preferredLanguage
    //}
    
    var locale: String {
        guard let preferedLanguage = Locale.preferredLanguages.first else {
            return "en"
        }
        return String(preferedLanguage[..<String.Index(encodedOffset: 2)])
    }
    
    /// Full localized language name
    public func displayName(for language: String) -> String? {
        let locale = NSLocale.current as NSLocale
        ///let locale = NSLocale(localeIdentifier: LocalizationManager.shared.currentLanguage)
        return locale.displayName(forKey: NSLocale.Key.identifier, value: language)?.capitalized ?? nil
    }
    
    var isoLanguageCodes: [String] {
        return Locale.availableIdentifiers
    }
    
    
    /// 1 vs 2 differences:
    ///Cocos (Keeling) Islands --- Cocos [Keeling] Islands
    ///Myanmar (Burma) --- Myanmar [Burma]
    ///
    /// 680 values for iOS 9 in 26.04.2018
    /// https://stackoverflow.com/questions/27875463/how-do-i-get-a-list-of-countries-in-swift-ios
    var countries: [String] {
        /// or 1
        return Locale.isoRegionCodes.compactMap {
            return Locale.current.localizedString(forRegionCode: $0)
        }
        
        /// or 2
        //return NSLocale.isoCountryCodes.compactMap { code -> String? in
        //    let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        //    return (NSLocale.current as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: id)
        //}
    }
    
    var countryCodes: [String] {
        /// or 1
        return Locale.isoRegionCodes
        /// or 2
        //return NSLocale.isoCountryCodes
    }
}



//============================================================================================

//import Foundation

//1
//extension NSLocale {
//
//    struct Locale {
//        let countryCode: String
//        let countryName: String
//    }
//
//    class func locales() -> [Locale] {
//
//        var locales = [Locale]()
//        for countryCode in NSLocale.ISOCountryCodes() {
//            let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: countryCode)!
//            let locale = Locale(countryCode: countryCode, countryName: countryName)
//            locales.append(locale)
//        }
//
//        return locales
//    }
//
//    // TODO: доделать
//    func getCountryCallingCode(countryRegionCode: String) -> String {
//
//        let prefixCodes = ["TA": "290", "SX": "1", "SS": "211", "EH": "213", "CW": "599", "BQ": "599", "AX": "358", "AC": "247", "AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
//        let countryDialingCode = prefixCodes[countryRegionCode]
//        return countryDialingCode!
//    }
//}

//        return ["AF":"+93", "AX":"+358", "AL":"+355", "DZ":"+213", "AS":"+1684", "AD":"+376", "AO":"+244", "AI":"+1264", "AQ":"+672", "AG":"+1268", "AR":"+54", "AM":"+374", "AW":"+297", "AU":"+61", "AT":"+43", "AZ":"+994", "BS":"+1242", "BH":"+973", "BD":"+880", "BB":"+1246", "BY":"+375", "BE":"+32", "BZ":"+501", "BJ":"+229", "BM":"+1441", "BT":"+975", "BO":"+591", "BA":"+387", "BW":"+267", "BR":"+55", "IO":"+246", "BN":"+673", "BG":"+359", "BF":"+226", "BI":"+257", "KH":"+855", "CM":"+237", "CA":"+1", "CV":"+238", "KY":"+345", "CF":"+236", "TD":"+235", "CL":"+56", "CN":"+86", "CX":"+61", "CC":"+61", "CO":"+57", "KM":"+269", "CG":"+242", "CD":"+243", "CK":"+682", "CR":"+506", "CI":"+225", "HR":"+385", "CU":"+53", "CY":"+357", "CZ":"+420", "DK":"+45", "DJ":"+253", "DM":"+1767", "DO":"+1849", "EC":"+593", "EG":"+20", "SV":"+503", "GQ":"+240", "ER":"+291", "EE":"+372", "ET":"+251", "FK":"+500", "FO":"+298", "FJ":"+679", "FI":"+358", "FR":"+33", "GF":"+594", "PF":"+689", "GA":"+241", "GM":"+220", "GE":"+995", "DE":"+49", "GH":"+233", "GI":"+350", "GR":"+30", "GL":"+299", "GD":"+1473", "GP":"+590", "GU":"+1671", "GT":"+502", "GG":"+44", "GN":"+224", "GW":"+245", "GY":"+595", "HT":"+509", "VA":"+379", "HN":"+504", "HK":"+852", "HU":"+36", "IS":"+354", "IN":"+91", "ID":"+62", "IR":"+98", "IQ":"+964", "IE":"+353", "IM":"+44", "IL":"+972", "IT":"+39", "JM":"+1876", "JP":"+81", "JE":"+44", "JO":"+962", "KZ":"+77", "KE":"+254", "KI":"+686", "KP":"+850", "KR":"+82", "KW":"+965", "KG":"+996", "LA":"+856", "LV":"+371", "LB":"+961", "LS":"+266", "LR":"+231", "LY":"+218", "LI":"+423", "LT":"+370", "LU":"+352", "MO":"+853", "MK":"+389", "MG":"+261", "MW":"+265", "MY":"+60", "MV":"+960", "ML":"+223", "MT":"+356", "MH":"+692", "MQ":"+596", "MR":"+222", "MU":"+230", "YT":"+262", "MX":"+52", "FM":"+691", "MD":"+373", "MC":"+377", "MN":"+976", "ME":"+382", "MS":"+1664", "MA":"+212", "MZ":"+258", "MM":"+95", "NA":"+264", "NR":"+674", "NP":"+977", "NL":"+31", "AN":"+599", "NC":"+687", "NZ":"+64", "NI":"+505", "NE":"+227", "NG":"+234", "NU":"+683", "NF":"+672", "MP":"+1670", "NO":"+47", "OM":"+968", "PK":"+92", "PW":"+680", "PS":"+970", "PA":"+507", "PG":"+675", "PY":"+595", "PE":"+51", "PH":"+63", "PN":"+872", "PL":"+48", "PT":"+351", "PR":"+1939", "QA":"+974", "RO":"+40", "RU":"+7", "RW":"+250", "RE":"+262", "BL":"+590", "SH":"+290", "KN":"+1869", "LC":"+1758", "MF":"+590", "PM":"+508", "VC":"+1784", "WS":"+685", "SM":"+378", "ST":"+239", "SA":"+966", "SN":"+221", "RS":"+381", "SC":"+248", "SL":"+232", "SG":"+65", "SK":"+421", "SI":"+386", "SB":"+677", "SO":"+252", "ZA":"+27", "SS":"+211", "GS":"+500", "ES":"+34", "LK":"+94", "SD":"+249", "SR":"+597", "SJ":"+47", "SZ":"+268", "SE":"+46", "CH":"+41", "SY":"+963", "TW":"+886", "TJ":"+992", "TZ":"+255", "TH":"+66", "TL":"+670", "TG":"+228", "TK":"+690", "TO":"+676", "TT":"+1868", "TN":"+216", "TR":"+90", "TM":"+993", "TC":"+1649", "TV":"+688", "UG":"+256", "UA":"+380", "AE":"+971", "GB":"+44", "US":"+1", "UY":"+598", "UZ":"+998", "VU":"+678", "VE":"+58", "VN":"+84", "VG":"+1284", "VI":"+1340", "WF":"+681", "YE":"+967", "ZM":"+260", "ZW":"+263"]

////2
//let countries: [(name: String, code: String, phoneCode: UInt64)] = {
//
//    var array: [(name: String, code: String, phoneCode: UInt64)] = []
//    let kit = PhoneNumberKit()
//
//    for i in 0..<kit.allCountries().count - 9 {
//        let countryCode = kit.allCountries()[i]
//        let countryName = NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: countryCode)!
//        let phoneCode = kit.codeForCountry(countryCode)!
//
//        array.append((name: countryName, code: countryCode, phoneCode: phoneCode))
//    }
//
//    array = array.sort { (left, right) -> Bool in
//        return left.name < right.name
//    }
//
//    return array
//}()
//
//
////3
//struct Country {
//    var name : String
//    var code : String
//    var phoneCode : UInt64
//}
//
//let countries: [Country] = {
//    var array: [Country] = []
//    let kit = PhoneNumberKit()
//
//    for i in 0..<kit.allCountries().count - 9 {
//        let countryCode = kit.allCountries()[i]
//        let countryName = NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: countryCode)!
//        let phoneCode = kit.codeForCountry(countryCode)!
//        let country = Country(name: countryName, code: countryCode, phoneCode: phoneCode)
//        array.append(country)
//    }
//
//    array = array.sort { (left, right) -> Bool in
//        return left.name < right.name
//    }
//
//    return array
//}()


//============================================================================================


//import Foundation

// TODO: try this
//extension NSLocale {
//
//    /// The country code for this locale. An example could be `US`.
//    public var countryCode2: String? {
//        return object(forKey: NSLocale.Key.countryCode) as? String
//    }
//
//    /// The country name for this locale. An example could be `United States`.
//    public var countryName: String? {
//        guard let countryCode = countryCode2 else { return nil }
//        return displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
//    }
//
//}
//
//// TODO: "if let" or "guard let"
//extension NSLocale {
//
//    static  var currentLanguageCode: String {
/////!!!!!//        Locale.current.languageCode
//        return NSLocale.current.objectForKey(NSLocaleLanguageCode) as! String
//    }
//
//    static var currentCountryName: String {
//        return NSLocale.current.displayNameForKey(NSLocaleCountryCode, value: NSLocale.currentLanguageCode)!
//    }
//}
//
//
//// TODO: try this
//// MARK: - Normal
//extension NSLocale {
//
//    class func languageAvailable() -> Array<String> {
//        var array = Array<String>()
//        let appleLanguages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as! [String]
//
//        for language in appleLanguages {
//            let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
//
//            if path != nil {
//                array.append(language)
//            }
//        }
//
//        return array
//    }
//
//    class func languageCode() -> String {
//
//        let languageAvailable = self.languageAvailable()
//        let preferredLanguages = NSLocale.preferredLanguages()
//        var currentLanguage = preferredLanguages.first
//
//        if !languageAvailable.contains(currentLanguage!) {
//            currentLanguage = "en"
//        }
//
//        return currentLanguage!
//    }
//
//}
//
//extension NSLocale {
//    var decimalSeparatorHelper: String {
//        return objectForKey(NSLocaleDecimalSeparator) as! String
//    }
//}
//
//import CoreTelephony
//public func defaultRegionCode() -> String {
//    //1
//    if let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider {
//        if let isoCountryCode = carrier.isoCountryCode {
//            return isoCountryCode.uppercaseString
//        }
//    }
//
//    //2
//    if let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String {
//        return countryCode
//    }
//    //3
//    return "en"
//}
