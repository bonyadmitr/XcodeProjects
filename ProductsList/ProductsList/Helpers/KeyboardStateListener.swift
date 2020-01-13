import UIKit

protocol KeyboardStateListenerDelegate: AnyObject {
    func keyboardWillShow(state: KeyboardState)
    func keyboardWillHide(state: KeyboardState)
//    func keyboardStateListener(_ keyboardStateListener: KeyboardStateListener, keyboardWillShowWithState state: KeyboardState)
////    func keyboardStateListener(_ keyboardStateListener: KeyboardStateListener, keyboardDidShowWithState state: KeyboardState)
//    func keyboardStateListener(_ keyboardStateListener: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState)
}
//extension KeyboardStateListenerDelegate {
//    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardDidShowWithState state: KeyboardState) {}
//}

final class KeyboardStateListener: NSObject {
    
    weak var delegate: KeyboardStateListenerDelegate?
//    private var offset: CGFloat = 0
//    private var keyboardVisibleHeight: CGFloat = 0
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotification),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardDidShowNotification),
//                                               name: UIWindow.keyboardDidShowNotification,
//                                               object: nil)
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
//        delegate?.keyboardStateListener(self, keyboardWillShowWithState: keyboardState)
        delegate?.keyboardWillShow(state: keyboardState)
    }
    
//    @objc func keyboardDidShowNotification(_ notification: Notification) {
//        let keyboardState = KeyboardState(notification.userInfo)
//        delegate?.keyboardStateListener(self, keyboardDidShowWithState: keyboardState)
//    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        let keyboardState = KeyboardState(notification.userInfo)
        delegate?.keyboardWillHide(state: keyboardState)
//        delegate?.keyboardStateListener(self, keyboardWillHideWithState: keyboardState)
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
