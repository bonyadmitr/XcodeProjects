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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        /// https://fabric.io/kits/ios/crashlytics/install
        ///
        /// Turn off automatic collection with a new key to your Info.plist file
        /// Key: firebase_crashlytics_collection_enabled, Value: false
        /// Enable collection for selected users by initializing Crashlytics at runtime
        Fabric.with([Crashlytics.self])
        
        crashlyticsLogs("app start")
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
        
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "id": 2,
            "name": "some name of user"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }


        
        
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

