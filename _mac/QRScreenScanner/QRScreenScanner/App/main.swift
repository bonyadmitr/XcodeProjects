import Cocoa

/// old simple
//let delegate = AppDelegate()
//NSApplication.shared.delegate = delegate
//NSApplication.shared.run()

autoreleasepool {
    let delegate = AppDelegate()
    /// code https://github.com/lapcat/NiblessMenu/blob/master/NiblessMenu/main.swift
    /// NSApplication delegate is a weak reference,
    /// so we have to make sure it's not deallocated.
    /// In Objective-C you would use NS_VALID_UNTIL_END_OF_SCOPE
    withExtendedLifetime(delegate, {
        let application = NSApplication.shared
        application.delegate = delegate
        application.run()
        application.delegate = nil
    })
}
