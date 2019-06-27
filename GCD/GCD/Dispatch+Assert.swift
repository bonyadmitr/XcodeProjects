import Foundation

/// https://developer.apple.com/swift/blog/?id=4
@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
func dispatchAssert(condition: @autoclosure () -> DispatchPredicate) {
    //if #available(iOS 10.0, *) {}
    #if DEBUG
    dispatchPrecondition(condition: condition())
    #endif
}

@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
func assertMainQueue() {
    dispatchAssert(condition: .onQueue(.main))
}

@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
func assertBackgroundQueue() {
    dispatchAssert(condition: .notOnQueue(.main))
}
