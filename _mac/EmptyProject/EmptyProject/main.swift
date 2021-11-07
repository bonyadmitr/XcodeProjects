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

//import Cocoa;class W:NSWindow{override func close(){NSApp.terminate(nil)}};let w=W(contentRect:CGRect(x:0,y:0,width:150,height:0),styleMask:[.titled,.closable,.miniaturizable,.resizable],backing:.buffered,defer:false);w.title="Hello World";w.center();w.makeKeyAndOrderFront(nil);NSApp.setActivationPolicy(.regular);NSApp.activate(ignoringOtherApps:true);NSApp.run()
