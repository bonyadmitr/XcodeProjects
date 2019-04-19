//
//  ViewController.swift
//  LaunchAtLogin
//
//  Created by Bondar Yaroslav on 4/19/19.
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

final class StartupLaunch: NSObject {
    
    class var isAppLoginItem: Bool {
        return itemReferencesInLoginItems.existingReference != nil
    }
    
    private class var itemReferencesInLoginItems: (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        
        if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
            let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray as! [LSSharedFileListItem]
            if loginItems.count > 0 {
                
                let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
                let itemUrl = UnsafeMutablePointer<Unmanaged<CFURL>?>.allocate(capacity: 1)
                defer { itemUrl.deallocate() }
                
                for i in loginItems {
                    if let itemUrl = LSSharedFileListItemCopyResolvedURL(i, 0, nil), itemUrl.takeRetainedValue() as URL == appUrl {
                        return (i, loginItems.last)
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
