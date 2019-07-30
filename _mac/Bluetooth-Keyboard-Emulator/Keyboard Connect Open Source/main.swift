//
//  main.swift
//  Keyboard Connect
//
//  Created by Arthur Yidi on 4/11/16.
//  Copyright © 2016 Arthur Yidi. All rights reserved.
//

import Cocoa

/// fork for swift 3
/// https://github.com/bpfoley/Bluetooth-Keyboard-Emulator/tree/swift3
func main(arguments: [String]) {
    let application = NSApplication.shared
    let delegate = AppDelegate()
    application.delegate = delegate

    func quit(signal: Int32) {
        NSApplication.shared.terminate(NSNumber(value: signal))
    }

    signal(SIGHUP, quit)
    signal(SIGINT, quit)
    signal(SIGTERM, quit)
    signal(SIGQUIT, quit)

    application.run()
}

main(arguments: CommandLine.arguments)

//let appDelegate = AppDelegate()
//NSApplication.shared.delegate = appDelegate
//NSApp.run()

/// https://stackoverflow.com/q/42875741
//let app = NSApplication.shared
//let appDelegate = AppDelegate()
//app.delegate = appDelegate
////_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

/// https://stackoverflow.com/questions/24009050/how-do-i-access-program-arguments-in-swift
//ProcessInfo.processInfo.arguments
