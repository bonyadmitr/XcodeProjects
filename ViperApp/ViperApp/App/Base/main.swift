//
//  main.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication

#if os(iOS)
UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(to: UnsafeMutablePointer<Int8>.self,
                    capacity: Int(CommandLine.argc)),
    NSStringFromClass(MainApplication.self),
    NSStringFromClass(AppDelegateProxy.self)
)
#elseif os(macOS)
import AppKit
//NSApplication.shared.delegate = MainAppDelegate()
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
//    NSApp.run()
#endif


