import FirebaseAnalytics
import UIKit.UIDevice

extension AnalyticsService {
    static let shared = AnalyticsService()
}

final class AnalyticsService {
    
    private let privateQueue = DispatchQueue(label: "\((#file as NSString).lastPathComponent): \(#line)")
    
    private let staticParameters: [String: Any] = {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            else {
                assertionFailure()
                return [:]
        }
        
        let appVersion = "\(version)-\(build)"
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let loginStatus = false
        
        let parameters: [String: Any] = [
            "appVersion": appVersion,
            "deviceId": deviceId,
            "loginStatus": String(loginStatus)
        ]
        
        assert((parameters.keys.first(where: { $0.count > 40 }) == nil),
               "Parameter names can be up to 40 characters long. unavailabel keys: \(parameters.keys.filter({ $0.count > 40 }))")
        
        /// if you don't like scary operations add "#if DEBUG" and move code to constants
        assert((parameters.keys.first(where: { !isAvalableEventName($0) }) == nil),
               "unavailabel keys: \(parameters.keys.filter({ !isAvalableEventName($0) }))" )
        
        /// if you don't like scary operations add "#if DEBUG" and move code to constants
        assert((parameters.values.compactMap({ $0 as? String}).first(where: { $0.count > 100 }) == nil),
               "parameter values can be up to 100 characters long. unavailabel values: \(parameters.values.compactMap({ $0 as? String}).filter( { $0.count > 100 }))")
        
        return parameters
    }()
    
    
    /**
     for assert Analytics.logEvent
     
     Should contain 1 to 40 alphanumeric characters or underscores.
     The name must start with an alphabetic character.
     
     #1 best result for 5 checks was 0.0010449886322021484
     
     private static let eventNameAllowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_")
     static func isAvalableEventName2(_ eventName: String) -> Bool {
     return eventName.unicodeScalars.allSatisfy { eventNameAllowedSet.contains($0) }
     }
     
     #2 best result for 5 checks was 0.0009319782257080078
     */
    private static func isAvalableEventName(_ eventName: String) -> Bool {
        
        if eventName.isEmpty {
            return false
        }
        
        /// The name must start with an alphabetic character
        if let firstChar = eventName.first, !(firstChar >= "a" && firstChar <= "z") && !(firstChar >= "A" && firstChar <= "Z") {
            return false
        }
        
        ///Should contain AlphaNumeric characters or underscores.
        for char in eventName {
            if !(char >= "a" && char <= "z") && !(char >= "A" && char <= "Z") && !(char == "_") && !(char >= "0" && char <= "9") {
                return false
            }
        }
        return true
    }
    
    // TODO: AnalyticsEventLogin const
    /// The name must start with an Alphabetic character.
    /// Should contain 1 to 40 AlphaNumeric characters or underscores.
    func log(event: String) {
        assert(!event.isEmpty && event.count <= 40, "Should contain 1 to 40 alphanumeric characters or underscores")
        assert(type(of: self).isAvalableEventName(event), "Analytics.logEvent doc")
        
        /// check token
        let loginStatus = false
        
        let dynamicParameters: [String: Any] = [
            "loginStatus": String(loginStatus)
        ]
        
        assert((dynamicParameters.keys.first(where: { $0.count > 40 }) == nil),
               "Parameter names can be up to 40 characters long. unavailabel keys: \(dynamicParameters.keys.filter({ $0.count > 40 }))")
        
        /// if you don't like scary operations add "#if DEBUG" and move code to constants
        assert((dynamicParameters.keys.first(where: { !type(of: self).isAvalableEventName($0) }) == nil),
               "unavailabel keys: \(dynamicParameters.keys.filter({ !type(of: self).isAvalableEventName($0) }))" )
        
        /// if you don't like scary operations add "#if DEBUG" and move code to constants
        assert((dynamicParameters.values.compactMap({ $0 as? String}).first(where: { $0.count > 100 }) == nil),
               "parameter values can be up to 100 characters long. unavailabel values: \(dynamicParameters.values.compactMap({ $0 as? String}).filter( { $0.count > 100 }))")
        
        
        /// dynamicParameters's value will be used when there is a conflict with the keys
        /// https://stackoverflow.com/a/50532046/5893286
        let parameters = staticParameters.merging(dynamicParameters) { $1 }
        
        privateQueue.async {
            Analytics.logEvent(event, parameters: parameters)
        }
    }
    
    /// To disable screen reporting, set the flag FirebaseScreenReportingEnabled to NO (boolean) in the Info.plist
    ///
    /// setScreenName:screenClass: must be called after a view controller has appeared
    func setScreenName(file: String = #file) {
        assert(Thread.isMainThread, "setScreenName doc")
        /// ViewController.swift
        
        /// will not work at all with "FirebaseScreenReportingEnabled NO"
        let fileName = (file as NSString).lastPathComponent
        Analytics.setScreenName(fileName, screenClass: nil)
        //        Analytics.setScreenName(nil, screenClass: nil)
        /// will not work at all. will not add parameters. DON'T USE IT
        /// log(event: "screen_view")
        
        //        log(event: "screen_view_")
    }
}
