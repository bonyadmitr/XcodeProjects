//
//  AppDelegate.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics
import Fabric
import Crashlytics
import FirebaseDatabase

func crashlyticsLogsLine(file: String = #file, line: UInt = #line, functionName: String = #function) {
    let fileName = (file as NSString).lastPathComponent
    crashlyticsLogs("\(fileName) \(line) \(functionName)")
}

/// https://firebase.google.com/docs/crashlytics/customize-crash-reports
///
/// don't call before "Fabric.with([Crashlytics.self])"
func crashlyticsLogs(_ string: String) {
    CLSLogv("%@", getVaList([string]))
}

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
    
    // TODO: AnalyticsEventLogin
    /// The name must start with an Alphabetic character.
    /// Should contain 1 to 40 AlphaNumeric characters or underscores.
    func log(event: String) {
        assert(!event.isEmpty && event.count > 40, "Should contain 1 to 40 alphanumeric characters or underscores")
        assert(type(of: self).isAvalableEventName(event), "Analytics.logEvent doc")
        
        /// check token
        let loginStatus = false
        
        let dynamicParameters: [String: Any] = [
            "loginStatus": String(loginStatus)
        ]
        
        /// dynamicParameters's value will be used when there is a conflict with the keys
        /// https://stackoverflow.com/a/50532046/5893286
        let parameters = staticParameters.merging(dynamicParameters) { $1 }
        
        //assert(parameters.count <= 40, "Analytics.logEvent doc")
        assert((parameters.keys.first(where: { $0.count > 40 }) == nil),
               "Parameter names can be up to 40 characters long. unavailabel keys: \(parameters.keys.filter({ $0.count > 40 }))")
        
        /// if you don't like scary operations add "#if DEBUG" and move code to constants
        assert((parameters.keys.first(where: { !type(of: self).isAvalableEventName($0) }) == nil),
               "unavailabel keys: \(parameters.keys.filter({ !type(of: self).isAvalableEventName($0) }))" )
        
        /// if you don't like scary operations add "#if DEBUG" and move code to constants
        assert((parameters.values.compactMap({ $0 as? String}).first(where: { $0.count > 100 }) == nil),
               "parameter values can be up to 100 characters long. unavailabel values: \(parameters.values.compactMap({ $0 as? String}).filter( { $0.count > 100 }))")
        
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private func configureFirebase() {
        let fileName: String
//        #if DEBUG
//        fileName = "GoogleService-Info-debug"
//        #else
        fileName = "GoogleService-Info"
//        #endif
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            assertionFailure("threre is no file: \(fileName) or problem with FirebaseOptions")
            FirebaseApp.configure()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureFirebase()
        
        AnalyticsService.shared.log(event: "app_start")
        
        /// https://fabric.io/kits/ios/crashlytics/install
        ///
        /// Turn off automatic collection with a new key to your Info.plist file
        /// Key: firebase_crashlytics_collection_enabled, Value: false
        /// Enable collection for selected users by initializing Crashlytics at runtime
//        Fabric.with([Crashlytics.self])
        
        crashlyticsLogs("app_start")
        crashlyticsLogsLine()
        
        /// https://firebase.google.com/docs/database/ios/read-and-write
//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
//
//        let userID = "qwe"
//        let newName = "some name"
//
//        /// rewrite all fields
//        //ref.child("users").child(userID).setValue(["username": newName])
//
//        /// update one field
//        //ref.child("users/\(userID)/name").setValue(newName)
//
//        ref.coll
//        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let all = snapshot.value as? [String: Any]
//            print(all)
////            let username = value?["username"] as? String ?? ""
////            let user = User(username: username)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        /// https://firebase.google.com/docs/firestore/quickstart
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let querySnapshot = querySnapshot {
                
                let users = querySnapshot.documents.map { $0.data() }
                print(users)
                
            } else {
                assertionFailure()
            }
        }
        
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "id": 2,
//            "name": "some name of user"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }


        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

