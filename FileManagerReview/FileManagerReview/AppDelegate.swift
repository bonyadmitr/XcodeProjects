//
//  AppDelegate.swift
//  FileManagerReview
//
//  Created by Yaroslav Bondar on 08.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// TODO: app with 1 feature: FileManager.default.removeItemWithoutPermissions(at: folderUrl)
// TODO: app with PosixPermissions set


/** apple source
 
 Foundation
 latest with linux https://github.com/apple/swift-corelibs-foundation/tree/main/Sources/Foundation
 swift3, apple only https://github.com/apple/swift-corelibs-foundation/blob/swift-3/Foundation
 SiriusObfuscator - apple source code by SymbolExtractor https://github.com/Polidea/SiriusObfuscator-SymbolExtractorAndRenamer/tree/master/swift-corelibs-foundation/Foundation
 
 
 */

