import Foundation

/// Building assert, Lazy Evaluation https://developer.apple.com/swift/blog/?id=4\
@available(iOS 10.0, *)
func dispatchAssert(condition: @autoclosure () -> DispatchPredicate) {
    #if DEBUG
    dispatchPrecondition(condition: condition())
    #endif
}

func assertMainQueue() {
    /// for iOS 9
    /// or #1:
    /// assert(Thread.isMainThread)
    ///
    /// or #2:
    /// assert(DispatchQueue.currentQueueLabel == DispatchQueue.main.label)
    
    if #available(iOS 10.0, *) {
        dispatchAssert(condition: .onQueue(.main))
    } else {
        assert(Thread.isMainThread)
    }
}

func assertBackgroundQueue() {
    if #available(iOS 10.0, *) {
        dispatchAssert(condition: .notOnQueue(.main))
    } else {
        assert(!Thread.isMainThread)
    }
}
