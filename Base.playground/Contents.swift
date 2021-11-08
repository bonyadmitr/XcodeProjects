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


// MARK: - usage example


/// printing __lldb_expr_NUMBER.Quote https://stackoverflow.com/a/30303457/5893286
/// to fix it used ReflectedStringConvertible
struct Quote: Decodable, ReflectedStringConvertible {
    let text: String
    let author: String?
}


