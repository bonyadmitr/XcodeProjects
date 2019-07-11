import Foundation

/// https://developer.apple.com/swift/blog/?id=4
func dispatchAssert(condition: @autoclosure () -> DispatchPredicate) {
    #if DEBUG
    if #available(iOS 10.0, *) {
        dispatchPrecondition(condition: condition())
    }
    #endif
}

func assertMainQueue() {
    /// for iOS 9
    /// or #1:
    /// assert(Thread.isMainThread)
    ///
    /// or #2:
    /// assert(DispatchQueue.currentQueueLabel == DispatchQueue.main.label)
    dispatchAssert(condition: .onQueue(.main))
}

func assertBackgroundQueue() {
    dispatchAssert(condition: .notOnQueue(.main))
}


/// https://developer.apple.com/swift/blog/?id=4
//@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
//func dispatchAssert(condition: @autoclosure () -> DispatchPredicate) {
//    //if #available(iOS 10.0, *) {}
//    #if DEBUG
//    dispatchPrecondition(condition: condition())
//    #endif
//}
//
//@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
//func assertMainQueue() {
//    dispatchAssert(condition: .onQueue(.main))
//}
//
//@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
//func assertBackgroundQueue() {
//    dispatchAssert(condition: .notOnQueue(.main))
//}
