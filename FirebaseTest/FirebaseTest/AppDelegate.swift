//
//  AppDelegate.swift
//  FirebaseTest
//
//  Created by Yaroslav Bondar on 16/07/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseFirestore

import Fabric
import Crashlytics


import FirebaseDatabase

// TODO: !!! it is not working !!!
final class FIRDatabaseService {
    
    /// https://firebase.google.com/docs/database/ios/read-and-write
    let ref = Database.database().reference()
    
    func getUsers() {

//        let userID = "qwe"
//        let newName = "some name"

        /// rewrite all fields
        //ref.child("users").child(userID).setValue(["username": newName])

        /// update one field
        //ref.child("users/\(userID)/name").setValue(newName)

        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let all = snapshot.value as? [String: Any]
            print(all ?? "nil")
//            let username = value?["username"] as? String ?? ""
//            let user = User(username: username)

            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

final class FirestoreService {
    
    /// https://firebase.google.com/docs/firestore/quickstart
    let db = Firestore.firestore()
    
    func getUsers() {
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
    }
    
    func createNewUser() {
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
        
        log("app_start")
        logLine()
        
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

