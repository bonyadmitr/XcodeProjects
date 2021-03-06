//
//  main.swift
//  LocalizationManager
//
//  Created by Bondar Yaroslav on 5/12/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// remove @UIApplicationMain in AppDelegate
UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(to: UnsafeMutablePointer<Int8>.self,
                    capacity: Int(CommandLine.argc)),
    NSStringFromClass(MainApplication.self),
    NSStringFromClass(AppDelegate.self)
)
