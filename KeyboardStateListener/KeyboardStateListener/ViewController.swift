import UIKit

final class ViewController: UIViewController {

    private let keyboardStateListener = KeyboardStateListener()
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardStateListener.delegate = self
        
        
        scrollView.subviews.first?.backgroundColor = UIColor.lightGray
        scrollView.backgroundColor = UIColor.lightGray
        view.backgroundColor = UIColor.lightGray
        
        view.addTapGestureToHideKeyboard()
    }
}
extension ViewController: KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillShowWithState state: KeyboardState) {
        let coveredHeight = state.keyboardHeightForView(scrollView)
//        state.animate {
//            self.scrollView.contentInset.bottom = coveredHeight
//        }
        self.scrollView.contentInset.bottom = coveredHeight
    }
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState) {
//        state.animate {
//            self.scrollView.contentInset.bottom = 0
//        }
        scrollView.contentInset.bottom = 0
    }
}




private extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeKeyboard() {
        let view: UIView = window ?? self
        view.endEditing(true)
    }
}





protocol KeyboardHelperDelegate: AnyObject {
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillShowWithState state: KeyboardState)
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState)
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
//        let q: TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
//
//        if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let frame = frameValue.cgRectValue
//            keyboardVisibleHeight = frame.size.height
//        }
//
//        self.updateConstant()
//        switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
//        case let (.some(duration), .some(curve)):
//
//            let options = UIView.AnimationOptions(rawValue: curve.uintValue)
//
//            UIView.animate(
//                withDuration: TimeInterval(duration.doubleValue),
//                delay: 0,
//                options: options,
//                animations: {
//                    UIApplication.shared.keyWindow?.layoutIfNeeded()
//            }, completion: nil)
//        default:
//
//            break
//        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        let keyboardState = KeyboardState(notification.userInfo)
        delegate?.keyboardHelper(self, keyboardWillHideWithState: keyboardState)
    }
}

//public struct KeyboardState2 {
//    let animationDuration: TimeInterval
//    let animationCurve: UIView.AnimationCurve
//    private let keyboardFrame: CGRect
//
//    init(_ userInfo: [AnyHashable: Any]) {
//        animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
//        // HACK: UIViewAnimationCurve doesn't expose the keyboard animation used (curveValue = 7),
//        // so UIViewAnimationCurve(rawValue: curveValue) returns nil. As a workaround, get a
//        // reference to an EaseIn curve, then change the underlying pointer data with that ref.
//        var curve = UIView.AnimationCurve.easeIn
//        if let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
//            let w = curveValue << 16
//            NSNumber(value: curveValue as Int).getValue(&curve)
//        }
//
//        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
//        let animationOptions = animationCurve << 16
//        let qq = UIView.AnimationOptions(rawValue: UInt(animationOptions))
//
//        var animationCurve2 = UIView.AnimationOptions.curveEaseInOut
//        (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.getValue(&animationCurve2)
//
//
//
////        let animationCurve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
////        let animationOptions = animationCurve << 16
//
//        self.animationCurve = curve
//
//        if let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            keyboardFrame = keyboardFrameValue.cgRectValue
//        } else {
//            keyboardFrame = .zero
//        }
//    }
//
//    /// Return the height of the keyboard that overlaps with the specified view. This is more
//    /// accurate than simply using the height of UIKeyboardFrameBeginUserInfoKey since for example
//    /// on iPad the overlap may be partial or if an external keyboard is attached, the intersection
//    /// height will be zero. (Even if the height of the *invisible* keyboard will look normal!)
//    public func intersectionHeightForView(_ view: UIView) -> CGFloat {
//        let convertedKeyboardFrame = view.convert(keyboardFrame, from: nil)
//        let intersection = convertedKeyboardFrame.intersection(view.bounds)
//        return intersection.size.height
//    }
//
//    func animate(_ block: @escaping () -> Void) {
//        let options = UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue))
//        UIView.animate(
//            withDuration: animationDuration,
//            delay: 0,
//            options: options,
//            animations: block,
//            completion: nil)
//    }
//}

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
