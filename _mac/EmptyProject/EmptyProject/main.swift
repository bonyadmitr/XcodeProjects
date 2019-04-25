import Cocoa

/// https://stackoverflow.com/a/28793059
let delegate = AppDelegate() //alloc main app's delegate class
NSApplication.shared.delegate = delegate //set as app's delegate

/// #1
NSApplication.shared.run()


/// Old versions:
/// NSApplicationMain(C_ARGC, C_ARGV)
/// #2
//_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv);  //start of run loop

//import Cocoa
//
//let delegate = AppDelegate()
//NSApplication.shared.delegate = delegate
//
//NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
