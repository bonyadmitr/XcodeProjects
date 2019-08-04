//
//  AppDelegate.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 7/23/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class MainMenuManager {
    
    static let shared = MainMenuManager()
    
    func setupMenu() {
        let appMenu = NSMenu(title: "App")
        //appMenu.autoenablesItems = false
        
        appMenu.addItem(withTitle: "About",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                        keyEquivalent: "a")
        
        appMenu.addItem(withTitle: "Quit",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")
        
//        let aboutMenuItem = NSMenuItem(title: "About 2", action: #selector(about), keyEquivalent: "z")
//        aboutMenuItem.target = self
//        appMenu.addItem(aboutMenuItem)
        
//        appMenu.addItem(withTitle: "About 2",
//                        action: #selector(about),
//                        keyEquivalent: "z").target = self
        
        let mainMenu = NSMenu(title: "MainMenu")
        mainMenu.addSubmenu(menu: appMenu)
        
        //let editMenu = mainMenu.addSubmenu(title: "Edit")
        
        NSApp.mainMenu = mainMenu
    }
    
//    @objc private func quit() {
//        NSApp.terminate(nil)
//    }

//    @objc private func about() {
//        NSApp.orderFrontStandardAboutPanel(self)
//    }
}

extension NSMenu {
    
    /// for title "Edit" will add emojy menuItem. it bcz of `addItem(withTitle: "Edit"`
    func addSubmenu(title: String) -> NSMenu {
        let menu = NSMenu(title: title)
        let menuItem = addItem(withTitle: title, action: nil, keyEquivalent: "")
        setSubmenu(menu, for: menuItem)
        return menu
    }
    
    func addSubmenu(menu: NSMenu) {
        let menuItem = addItem(withTitle: menu.title, action: nil, keyEquivalent: "")
        setSubmenu(menu, for: menuItem)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        ScreenManager.disableHardwareMirroring()
//        ScreenManager.allDisplayImages()
//        ScreenManager.toggleMirroring()
        
//        let window = ScreenManager.compositedWindow(for: "Google Chrome")
//        let w = ScreenManager.compositedWindowsByName()
        //let e = ScreenManager.windowsByName()
        //ScreenManager.visibleWindowsImages()
        
        MainMenuManager.shared.setupMenu()
        showWindow()
        statusItem = createStatusItem()
    }
    
//    private func setupMenu() {
//        let mainMenu = NSMenu(title: "MainMenu")
//        let applicationMenuItem = mainMenu.addItem(withTitle: "Application", action: nil, keyEquivalent: "")
//        let applicationSubmenu = NSMenu(title: "Application")
//        let quitMenuItem = applicationSubmenu.addItem(withTitle: "Quit",
//                                                      action: #selector(NSApplication.terminate),
//                                                      keyEquivalent: "q")
//        quitMenuItem.target = NSApp
//        mainMenu.setSubmenu(applicationSubmenu, for: applicationMenuItem)
//        NSApp.mainMenu = mainMenu
//    }
    
    /// without storyboard can be create by lazy var + `_ = statusItem`.
    /// otherwise will be errors "0 is not a valid connection ID".
    /// https://habr.com/ru/post/447754/
    private func createStatusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return statusItem
        }
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.title = "QR"
        button.action = #selector(clickStatusItem)
        return statusItem
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private lazy var window: NSWindow? = {
        /// if you have error "doesn't contain a view controller with identifier" save storyboard manually cmd+s
//        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
//        let windowIdentifier = NSStoryboard.SceneIdentifier("MainWindow")
//
//        guard let mainWindowController = mainStoryboard.instantiateController(withIdentifier: windowIdentifier) as? NSWindowController else {
//            assertionFailure()
//            return nil
//        }
//
//        /// instead of "nil" can be "self"
//        mainWindowController.showWindow(nil)
//
//        return mainWindowController.window
        let window = NSWindow(contentViewController: ViewController())
        window.center()
        return window
    }()

    @objc private func clickStatusItem() {
        
//        self.screenImageView.image = NSImage(cgImage: img, size: .init(width: img.width, height: img.height))
//
//        window.makeKeyAndOrderFront(nil)
        /// addition if need
        //NSApp.activate(ignoringOtherApps: true)
        /// not work
        //window.orderBack(self)
        
        //let qrValues = ScreenManager.allDisplayImages2()
        let qrValues = ScreenManager.getHiddenWindowsImages()
            .flatMap { CodeDetector.shared.readQR(from: $0) }
        saveQRValues(qrValues)
        showWindow()
    }
    
    private func showWindow() {
        
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
    
    private func saveQRValues(_ qrValues: [String]) {
        let qrDataSources = qrValues.map { qrValue -> HistoryDataSource in
            [TableColumns.date.rawValue: Date(),TableColumns.value.rawValue: qrValue]
        }
        let tableDataSource: [HistoryDataSource]
        if let tableDataSourceOld = UserDefaults.standard.array(forKey: "historyDataSource") as? [HistoryDataSource] {
            tableDataSource = tableDataSourceOld + qrDataSources
        } else {
            tableDataSource = qrDataSources
        }
        UserDefaults.standard.set(tableDataSource, forKey: "historyDataSource")
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
