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
 

 
 
 
 FileManager
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager+POSIX.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestFileManager.swift
 
 Data
 new / fread / readChunk https://github.com/weichsel/ZIPFoundation/blob/development/Sources/ZIPFoundation/Data%2BSerialization.swift
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/Data.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSData.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestNSData.swift
 
 
 URL
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/URL.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestURL.swift
 NSURL
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestNSURL.swift
 
 
 deletingLastPathComponent source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSPathUtilities.swift#L241
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/URL.swift#L810
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L874
 https://github.com/apple/swift-corelibs-foundation/blob/main/CoreFoundation/URL.subproj/CFURL.c#L4916
 https://github.com/opensource-apple/CF/blob/master/CFURL.c#L4532
 
 resourceValues(forKeys
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L594
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L663
 storage init https://github.com/apple/swift-corelibs-foundation/blob/main/CoreFoundation/URL.subproj/CFURL.c#L5320
 
 
 
 URLCache
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/FoundationNetworking/URLCache.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestURLCache.swift
 
 
 NSCache
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSCache.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestNSCache.swift
 
 */




/**
 TODO
 
 check https://github.com/GianniCarlo/DirectoryWatcher
 check https://github.com/vmanot/Filesystem
 check PosixPermissions vs FilePermission https://github.com/vmanot/Filesystem/blob/master/Sources/Intramodular/Access%20Control/FilePermission.swift
 

 
 */
