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
        
        let appVersion = "\(version) (\(build))"
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let loginStatus = false
        
        let parameters: [String: Any] = [
            "appVersion": appVersion,
            "deviceId": deviceId,
            "loginStatus": String(loginStatus)
        ]
        return parameters
    }()
    
    func log(event: String) {
        assert(event.count <= 40, "Analytics.logEvent doc")
        /// check token
        let loginStatus = false
        
        let dynamicParameters: [String: Any] = [
            "loginStatus": String(loginStatus)
        ]
        
        /// dynamicParameters's value will be used when there is a conflict with the keys
        /// https://stackoverflow.com/a/50532046/5893286
        let parameters = staticParameters.merging(dynamicParameters) { $1 }
        assert(parameters.count <= 40, "Analytics.logEvent doc")
        assert((parameters.values.compactMap({ $0 as? String}).first(where: { $0.count > 100 }) == nil), "Analytics.logEvent doc")
        
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
        let fileName = (file as NSString).lastPathComponent
        Analytics.setScreenName(fileName, screenClass: nil)
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

