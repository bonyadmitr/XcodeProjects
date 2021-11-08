import Foundation


// 🍑🍓🍒🥑🍌🍎🍊🍍🍋🥥🍇🍉🥝🍏🍅🍈🍐🫐🥭
// for _ in 1...10 { print("🍏") }

/// playground error in iOS
/// solution: open right panael - playground settings - macOS

/// we essentially tell the playground to keep running until we tell it to stop — which we do using a call to .finishExecution()
//import PlaygroundSupport
//PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.finishExecution()

/// Exception breakpoint
NSSetUncaughtExceptionHandler { exception in print("💥 \(exception)") }
//NSObject().value(forKey: "1") /// Exception example


