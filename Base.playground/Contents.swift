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


print("started")

//let data = try "quotes.json".file()
//let quotes = try JSONDecoder.shared.decode([Quote].self, from: data)

print(
    try "quotes.json".decodeFileJson(type: [Quote].self)
)

/// long operations
//print(
//    try "quotes.json".decodeFileJson(type: [FailableDecodable<Quote>].self).compactMap { $0.base }
//)

print(
    try """
    [
        {
            "text": "Music in the soul can be heard by the universe.",
            "author": "Lao Tzu"
        },
        {
            "text": "What we see depends mainly on what we look for.",
            "author": "John Lubbock"
        },
    ]
    """.decodeJson(type: [Quote].self)
)

/// possible playground error in iOS
/// solution: open right panael - playground settings - macOS
//error: Execution was interrupted, reason: EXC_BAD_ACCESS (code=1, address=0x18).
//The process has been left at the point where it was interrupted, use "thread return -x" to return to the state before expression evaluation.
print(
    try """
    [
        {
            "text": "Music in the soul can be heard by the universe.",
            "author": "Lao Tzu"
        },
        {
            "text": "What we see depends mainly on what we look for."
        }
    ]
    """.decodeJson(type: [FailableDecodable<Quote>].self).compactMap { $0.base }
)






class SomeStruct: ReflectedStringConvertible {
    var text: String = "123"
}
class SomeClass: ReflectedStringConvertible {
    var text: String = "123"
}
class SomeNSClass: NSObject, ReflectedStringConvertible {
    var text: String = "123"
    
    override var description : String {
        return desc
    }
}

class SomeNSClass2: SomeNSClass {
    var text2: String = "456"
}

print(SomeStruct())
print(SomeClass())
print(SomeNSClass())
print(SomeNSClass2())