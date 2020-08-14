import UIKit

/// old
//final class MulticastDelegate <T> {
//    private var weakDelegates = [WeakWrapper]()
//
//    func add(_ delegate: T) {
//        #if DEBUG
//        ///prevent adding the same object more then once
//        guard (weakDelegates.first { $0.value === delegate as AnyObject } == nil) else {
//            return
//        }
//        #endif
//        weakDelegates.append(WeakWrapper(value: delegate as AnyObject))
//    }
//
//    func remove(_ delegate: T) {
//        weakDelegates = weakDelegates.filter { $0.value !== delegate as AnyObject }
//    }
//
//    func removeAll() {
//        weakDelegates.removeAll()
//    }
//
//    func invoke(invocation: (T) -> Void) {
//        /// Enumerating in reverse order prevents a race condition from happening when removing elements.
//        for (index, delegate) in weakDelegates.enumerated().reversed() {
//            if let delegate = delegate.value as? T {
//                invocation(delegate)
//            } else {
//                weakDelegates.remove(at: index)
//            }
//        }
//    }
//}
//private final class WeakWrapper {
//    weak var value: AnyObject?
//
//    init(value: AnyObject) {
//        self.value = value
//    }
//}
//

/// https://github.com/jonasman/MulticastDelegate/blob/master/Sources/MulticastDelegate/MulticastDelegate.swift
//final class MulticastDelegate<T> {
//    private let delegates = NSHashTable<AnyObject>.weakObjects()
//
//    /// will not add two same objects
//    /// Value Types will be ignored
//    func addDelegate(_ delegate: T) {
//        delegates.add(delegate as AnyObject)
//    }
//
//    func removeDelegate(_ delegate: T) {
//        delegates.remove(delegate as AnyObject)
//    }
//
//    func invokeDelegates(_ invocation: (T) -> ()) {
//        for delegate in delegates.allObjects {
//            /// for performance can be used unsafe invocation(delegate as! T)
//            if let delegate = delegate as? T {
//                invocation(delegate)
//            } else {
//                assertionFailure("delegate is not T")
//            }
//        }
//    }
//}
protocol KeyboardHelperDelegate: AnyObject {
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillShowWithState state: KeyboardState)
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardDidShowWithState state: KeyboardState)
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState)
}
extension KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardDidShowWithState state: KeyboardState) {}
}

final class KeyboardStateListener: NSObject {
    
    weak var delegate: KeyboardHelperDelegate?
    private var offset : CGFloat = 0
    private var keyboardVisibleHeight : CGFloat = 0
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotification),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShowNotification),
                                               name: UIWindow.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideNotification),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardState = KeyboardState(notification.userInfo)
        delegate?.keyboardHelper(self, keyboardWillShowWithState: keyboardState)
    }
    
    @objc func keyboardDidShowNotification(_ notification: Notification) {
        let keyboardState = KeyboardState(notification.userInfo)
        delegate?.keyboardHelper(self, keyboardDidShowWithState: keyboardState)
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        let keyboardState = KeyboardState(notification.userInfo)
        delegate?.keyboardHelper(self, keyboardWillHideWithState: keyboardState)
    }
}

public struct KeyboardState {
    let animationDuration: TimeInterval
    let animationOptions: UIView.AnimationOptions
    private let keyboardFrame: CGRect
    
    init(_ userInfo: [AnyHashable: Any]?) {
        
        guard let userInfo = userInfo else {
            assertionFailure()
            self.animationDuration = 0.25
            self.animationOptions = .curveEaseInOut
            keyboardFrame = .zero
            return
        }
        
        if let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            self.animationDuration = animationDuration
        } else {
            assertionFailure()
            self.animationDuration = 0.25
        }
        
        if let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            /// in most cases animationCurveValue = 7
            /// https://gist.github.com/kristopherjohnson/13d5f18b0d56b0ea9242
            ///
            /// another solution
            /// https://github.com/mozilla-mobile/firefox-ios/blob/master/Shared/KeyboardHelper.swift
            self.animationOptions = UIView.AnimationOptions(rawValue: animationCurveValue << 16)
        } else {
            assertionFailure()
            self.animationOptions = .curveEaseInOut
        }
        
        if let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardFrame = keyboardFrameValue
        } else {
            assertionFailure()
            keyboardFrame = .zero
        }
    }
    
    /// Return the height of the keyboard that overlaps with the specified view. This is more
    /// accurate than simply using the height of UIKeyboardFrameBeginUserInfoKey since for example
    /// on iPad the overlap may be partial or if an external keyboard is attached, the intersection
    /// height will be zero. (Even if the height of the *invisible* keyboard will look normal!)
    ///
    /// also https://stackoverflow.com/a/32319698/5893286
    ///
    /// for more options see
    /// https://github.com/IdleHandsApps/IHKeyboardAvoiding/blob/master/Sources/KeyboardAvoiding.swift
    func keyboardHeightForView(_ view: UIView) -> CGFloat {
        let convertedKeyboardFrame = view.convert(keyboardFrame, from: nil)
        let intersection = convertedKeyboardFrame.intersection(view.bounds)
        return intersection.size.height
    }
    
    func animate(_ block: @escaping () -> Void) {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationOptions,
            animations: block,
            completion: nil)
    }
}
