//
//  ViewController.swift
//  LaunchAtLoginDepricated
//
//  Created by Bondar Yaroslav on 4/26/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


import Foundation

/// new tutorials
/// https://stackoverflow.com/questions/35339277/make-swift-cocoa-app-launch-on-startup-on-os-x-10-11
///
/// https://github.com/sindresorhus/LaunchAtLogin
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLogin/LaunchAtLogin.swift
/// https://github.com/sindresorhus/LaunchAtLogin/blob/master/LaunchAtLoginHelper/main.swift


final class StartupLaunch2 {
    
    static let shared = StartupLaunch2()
    
    private let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
    
    private let loginItemRef: LSSharedFileList = {
        return LSSharedFileListCreate(nil,
                                      kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                      nil).takeRetainedValue() as LSSharedFileList
    }()
    
    private func loginItems() -> [LSSharedFileListItem]? {
        return LSSharedFileListCopySnapshot(loginItemRef,
                                            nil).takeRetainedValue() as? [LSSharedFileListItem]
    }
    
    private func appItem(from loginItems: [LSSharedFileListItem]) -> LSSharedFileListItem? {
        return loginItems.first(where: { item in
            let itemUrl = LSSharedFileListItemCopyResolvedURL(item, 0, nil).takeRetainedValue() as URL
            return itemUrl == appUrl
        })
    }
    
    func setLogin(login: Bool) {
        
        guard let loginItems = loginItems() else {
            assertionFailure()
            return
        }
        
        if login {
            LSSharedFileListInsertItemURL(loginItemRef, loginItems.last, nil, nil, appUrl as CFURL, nil, nil)
        } else {
            guard let appItem = appItem(from: loginItems) else {
                assertionFailure("don't turn off LaunchAtLogin if it is already off")
                return
            }
            LSSharedFileListItemRemove(loginItemRef, appItem)
        }
        
    }
    
    func isAppLoginItem() -> Bool {
        guard let loginItems = loginItems() else {
            assertionFailure()
            return false
        }
        return appItem(from: loginItems) != nil
    }
    
    func toggle() {
        setLogin(login: !isAppLoginItem())
    }
}


/// https://github.com/ptsochantaris/trailer/blob/master/Trailer/StartupLaunch.swift
final class StartupLaunch: NSObject {
    
    class var isAppLoginItem: Bool {
        return itemReferencesInLoginItems.existingReference != nil
    }
    
    private class var itemReferencesInLoginItems: (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        
        if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
            
            let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as! [LSSharedFileListItem]
            
            if loginItems.count > 0 {
                
                let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
                
//                let itemUrl = UnsafeMutablePointer<Unmanaged<CFURL>?>.allocate(capacity: 1)
//                defer { itemUrl.deallocate() }
                
                for item in loginItems {
//                    LSSharedFileListItemResolve(item, 0, itemUrl, nil)
                    
                    if let itemUrl = LSSharedFileListItemCopyResolvedURL(item, 0, nil),
                        itemUrl.takeRetainedValue() as URL == appUrl
                    {
//                        let q = LSSharedFileListItemRemove(loginItemsRef, item)
//                        print(q)
                        return (item, loginItems.last)
                    }
                }
                return (nil, loginItems.last)
                
            } else {
                return(nil, kLSSharedFileListItemBeforeFirst.takeRetainedValue())
            }
        }
        return (nil, nil)
    }
    
    static func setLaunchOnLogin(_ launch: Bool) {
        
        let itemReferences = itemReferencesInLoginItems
        let isSet = itemReferences.existingReference != nil
        let type = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
        
        if let loginItemsRef = LSSharedFileListCreate(nil, type, nil).takeRetainedValue() as LSSharedFileList? {
            
            if launch && !isSet {
                let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL
                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
                //                DLog("Trailer was added to login items")
            } else if !launch && isSet, let itemRef = itemReferences.existingReference {
                LSSharedFileListItemRemove(loginItemsRef, itemRef)
                //                DLog("Trailer was removed from login items")
            }
        }
    }
    
}

//func applicationIsInStartUpItems() -> Bool {
//    return (itemReferencesInLoginItems().existingReference != nil)
//}
//
//func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?) {
//
//    if let appUrl : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
//        let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef?
//        if loginItemsRef != nil {
//            let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
//            if(loginItems.count > 0) {
//                let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as! LSSharedFileListItemRef
//                for var i = 0; i < loginItems.count; ++i {
//                    let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(i) as! LSSharedFileListItemRef
//                    if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
//                        if (itemURL.takeRetainedValue() as NSURL).isEqual(appUrl) {
//                            return (currentItemRef, lastItemRef)
//                        }
//                    }
//                }
//                return (nil, lastItemRef)
//            } else {
//                let addatstart: LSSharedFileListItemRef = kLSSharedFileListItemBeforeFirst.takeRetainedValue()
//                return(nil,addatstart)
//            }
//        }
//    }
//    return (nil, nil)
//}
//
//func toggleLaunchAtStartup() {
//    let itemReferences = itemReferencesInLoginItems()
//    let shouldBeToggled = (itemReferences.existingReference == nil)
//    if let loginItemsRef = LSSharedFileListCreate( nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef? {
//        if shouldBeToggled {
//            if let appUrl : CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
//                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
//            }
//        } else {
//            if let itemRef = itemReferences.existingReference {
//                LSSharedFileListItemRemove(loginItemsRef,itemRef);
//            }
//        }
//    }
//}



//---------------------------


/// https://github.com/KrauseFx/overkill-for-mac/blob/84cda74a02b3065f11b522fc6589c259a5894575/Overkill/LaunchStarter.swift
func applicationIsInStartUpItems() -> Bool {
    return itemReferencesInLoginItems().existingReference != nil
}

func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
    let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue()
    
    guard let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as? [LSSharedFileListItem],
        let lastItemRef = loginItems.last else {
            return (nil, nil)
    }
    
    let appURL = NSURL.fileURL(withPath: Bundle.main.bundlePath) as NSURL
    let currentItemRef = loginItems.first { currentItemRef in
        if let itemURL = url(currentItemRef) {
            return itemURL.isEqual(appURL)
        }
        return false
    }
    
    return (currentItemRef, lastItemRef)
}

func toggleLaunchAtStartup() {
    let itemReferences = itemReferencesInLoginItems()
    let appUrl = NSURL.fileURL(withPath: Bundle.main.bundlePath)
    let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue()
    
    guard let existingReference = itemReferences.existingReference else {
        if let lastReference = itemReferences.lastReference {
            LSSharedFileListInsertItemURL(loginItemsRef, lastReference, nil, nil, appUrl as CFURL, nil, nil)
        }
        return
    }
    
    if let itemURL = url(existingReference) {
        LSSharedFileListItemRemove(loginItemsRef, get(item: itemURL))
    }
}

// MARK - Private functions
private func get(item byURL: NSURL) -> LSSharedFileListItem? {
    let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue()
    
    guard let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as? [LSSharedFileListItem] else {
        return nil
    }
    
    let item = loginItems.first { currentItemRef in
        if let itemURL = url(currentItemRef) {
            return itemURL.isEqual(byURL)
        }
        return false
    }
    return item
}

private func url(_ item: LSSharedFileListItem?) -> NSURL? {
    var error: Unmanaged<CFError>? = nil
    let ret = LSSharedFileListItemCopyResolvedURL(item, 0, &error)
    if error == nil {
        return ret!.takeRetainedValue() as NSURL
    }
    // Normally: Error Domain=NSCocoaErrorDomain Code=4 "The file doesn’t exist."
    return nil
}
