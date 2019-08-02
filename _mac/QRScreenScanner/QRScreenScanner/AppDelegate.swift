//
//  AppDelegate.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 7/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// https://habr.com/ru/post/447754/
    /// NSStatusItem.variableLength
    private let statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return statusItem
        }
        button.title = "QR"
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.action = #selector(clickStatusItem)
        
        return statusItem
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ScreenManager.allScreensImages()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private lazy var window: NSWindow? = {
        /// if you have error "doesn't contain a view controller with identifier" save storyboard manually cmd+s
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let windowIdentifier = NSStoryboard.SceneIdentifier("MainWindow")
        
        guard let mainWindowController = mainStoryboard.instantiateController(withIdentifier: windowIdentifier) as? NSWindowController else {
            assertionFailure()
            return nil
        }
        
        /// instead of "nil" can be "self"
        mainWindowController.showWindow(nil)
        
        return mainWindowController.window
    }()

    @objc private func clickStatusItem() {
        
        guard let img = ScreenManager.mainScreenImage() else {
            assertionFailure()
            return
        }
        
//        self.screenImageView.image = NSImage(cgImage: img, size: .init(width: img.width, height: img.height))
//
//        window.makeKeyAndOrderFront(nil)
        /// addition if need
        //NSApp.activate(ignoringOtherApps: true)
        /// not work
        //window.orderBack(self)
        
        
//        "historyDataSource"
        
        for qrValue in CodeDetector.shared.readQR(from: img) {
            let newItem: HistoryDataSource = [TableColumns.date.rawValue: Date(),
                                              TableColumns.value.rawValue: qrValue]
            
            let tableDataSource: [HistoryDataSource]
            if var tableDataSourceOld = UserDefaults.standard.array(forKey: "historyDataSource") as? [HistoryDataSource] {
                tableDataSourceOld.append(newItem)
                tableDataSource = tableDataSourceOld
            } else {
                tableDataSource = [newItem]
            }
            UserDefaults.standard.set(tableDataSource, forKey: "historyDataSource")
            
        }
        
        
        
        guard let window = self.window else {
            assertionFailure()
            return
        }
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        /// to fix frame of closed window
//        window.setFrame(NSRect(x: 0, y: 0, width: 400, height: 300), display: true)
//        window.center()
        
        /// without reference it will be deinited
//        self.mainWindowController = mainWindowController
    }
    
    /// to open app after close button click we only hide it
    /// https://stackoverflow.com/a/43332520
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        
        return true
    }
}

/**
 RogueMacApp
 https://github.com/MalwareSec/RogueMacApp + all connected monitors
 http://distributeddigital.io/RogueApp.html
 
 problem wth fast user switch
 https://stackoverflow.com/questions/31475656/issues-with-screen-capture-on-os-x-cgdisplaycreateimage
 
 isRunningScreensaver
 https://github.com/nst/ScreenTime/blob/master/ScreenTime/ScreenShooter.swift
 
 all connected monitors
 https://stackoverflow.com/questions/39691106/programmatically-screenshot-swift-3-macos
 
 Screenshot + screen video + example
 https://github.com/nirix/swift-screencapture

 all windows screenshots. from apple. (project needs update to run)
 https://developer.apple.com/library/archive/samplecode/SonOfGrab/Introduction/Intro.html
 */
final class ScreenManager {
    
    enum CGResult<T> {
        case success(T)
        case failure(CGError)
    }
    
    static func mainScreenImage() -> CGImage? {
        return CGDisplayCreateImage(CGMainDisplayID())
    }
    
    /// reed doc of CGGetActiveDisplayList
    static func allScreensImages2() -> [CGImage] {
        
        var displayCount: UInt32 = 0;
        var getDisplayListResult = CGGetActiveDisplayList(0, nil, &displayCount)
        
        guard getDisplayListResult == .success  else {
            assertionFailure("CGGetActiveDisplayList failed: \(getDisplayListResult)")
            return []
        }
        
        let allocatedDisplayCount = Int(displayCount)
        
        /// or #1
        /// https://stackoverflow.com/a/41585973/5893286
        //var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        //getDisplayListResult = CGGetActiveDisplayList(displayCount, &displaysIds, &displayCount)
        //
        //guard getDisplayListResult == .success  else {
        //    assertionFailure("CGGetActiveDisplayList 2 failed: \(getDisplayListResult)")
        //    return []
        //}
        //
        //return displaysIds.compactMap { CGDisplayCreateImage($0) }
        
        /// or #2
        let displaysIds = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocatedDisplayCount)
        getDisplayListResult = CGGetActiveDisplayList(displayCount, displaysIds, &displayCount)
        
        guard getDisplayListResult == .success  else {
            assertionFailure("CGGetActiveDisplayList 2 failed: \(getDisplayListResult)")
            return []
        }
        
        return (0..<allocatedDisplayCount).compactMap { CGDisplayCreateImage(displaysIds[$0]) }
    }
    
    @discardableResult
    func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
        /// or #1
        //let bitmapRep = NSBitmapImageRep(cgImage: image)
        //guard let jpegData = bitmapRep.representation(using: .png, properties: [:]) else {
        //    assertionFailure()
        //    return false
        //}
        //do {
        //    try jpegData.write(to: destinationURL, options: .atomic)
        //    return true
        //} catch {
        //    assertionFailure(error.localizedDescription)
        //    return false
        //}
        
        /// or #2
        /// https://stackoverflow.com/a/40371604/5893286
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else {
            assertionFailure(destinationURL.absoluteString)
            return false
        }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }
    
    static func displayCount() -> CGResult<UInt32> {
        var displayCount: UInt32 = 0;
        let getDisplayListResult = CGGetActiveDisplayList(0, nil, &displayCount)
        
        guard getDisplayListResult == .success else {
            assertionFailure("CGGetActiveDisplayList failed: \(getDisplayListResult)")
            return .failure(getDisplayListResult)
        }
        return .success(displayCount)
    }
    
    static func displayIds(for displayCount: UInt32) -> CGResult<[CGDirectDisplayID]> {
        /// https://stackoverflow.com/a/41585973/5893286
        let allocatedDisplayCount = Int(displayCount)
        var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        let getDisplayListResult = CGGetActiveDisplayList(displayCount, &displaysIds, nil)
        
        guard getDisplayListResult == .success  else {
            assertionFailure("CGGetActiveDisplayList 2 failed: \(getDisplayListResult)")
            return .failure(getDisplayListResult)
        }
        
        return .success(displaysIds)
    }
    
    /// reed doc of CGGetActiveDisplayList
    static func allScreensImages() -> [CGImage] {
        switch displayCount() {
        case .success(let displayCount):
            
            switch displayIds(for: displayCount) {
            case .success(let displayIds):
                return displayIds.compactMap { CGDisplayCreateImage($0) }
            case .failure(let error):
                assertionFailure("CGGetActiveDisplayList failed: \(error)")
                return []
            }
            
        case .failure(let error):
            assertionFailure("CGGetActiveDisplayList failed: \(error)")
            return []
        }
    }
    
}
