import UIKit

final class ViewController: UIViewController {

    private let keyboardStateListener = KeyboardStateListener()
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var someTextField: UITextField!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    /// same as scrollViewBottomConstraint
    private lazy var scrollViewBottomConstraint2: NSLayoutConstraint? = {
        return self.view.constraints.first {
            //return $0.secondAttribute == .bottom && $0.secondItem === scrollView// && $0.firstAttribute == .bottom
            return $0.secondAttribute == .bottom && $0.secondItem is UIScrollView
        }
    }()
    
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
        
//        self.scrollView.frame.size.height -= coveredHeight
        
//        scrollViewBottomConstraint.constant = coveredHeight
        scrollViewBottomConstraint2?.constant = coveredHeight
        UIView.animate(withDuration: state.animationDuration) {
            self.view.layoutIfNeeded()
        }
        
        
//        self.scrollView.contentInset.bottom = coveredHeight
//        self.scrollView.scrollIndicatorInsets.bottom = coveredHeight
        
        
        
        
        
//        let scrollPoint = CGPoint(x: 0, y: someTextField.frame.origin.y - coveredHeight + 16)
//        scrollView.setContentOffset(scrollPoint, animated: true)
        
//        self.scrollView.contentOffset = CGPoint(x: 0, y: 1000)
//        self.scrollView.scroll(to: self.someTextField)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.scrollView.scroll(to: self.someTextField)
//        }
    }
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardDidShowWithState state: KeyboardState) {
//        let coveredHeight = state.keyboardHeightForView(scrollView)
        //        state.animate {
        //            self.scrollView.contentInset.bottom = coveredHeight
        //        }
        
//        self.scrollView.contentInset.bottom = coveredHeight
//        self.scrollView.scrollIndicatorInsets.bottom = coveredHeight
        
//                let scrollPoint = CGPoint(x: 0, y: someTextField.frame.origin.y - coveredHeight + 16)
//                scrollView.setContentOffset(scrollPoint, animated: true)
        
//        self.scrollView.scroll(to: self.someTextField)
    }
    func keyboardHelper(_ keyboardHelper: KeyboardStateListener, keyboardWillHideWithState state: KeyboardState) {
//        state.animate {
//            self.scrollView.contentInset.bottom = 0
//        }
        
//        scrollView.contentInset.bottom = 0
//        scrollView.scrollIndicatorInsets.bottom = 0
        
//        scrollViewBottomConstraint.constant = 0
        scrollViewBottomConstraint2?.constant = 0
        UIView.animate(withDuration: state.animationDuration) {
            self.view.layoutIfNeeded()
        }
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

//final class AdvancedScrollView: UIScrollView {
//    func scrollToView(_ view: UIView) {
//        let rect = convert(view.frame, to: self)
//        scrollRectToVisible(rect, animated: true)
//    }
//
//    func scrollToViews(_ views: [UIView]) {
//        if views.isEmpty {
//            return
//        }
//
//        let rects: [CGRect] = views.map { convert($0.frame, to: self) }
//
//        /// check for isEmpty is above
//        let firstRect = rects[0]
//        let unionRect: CGRect = rects.dropFirst().reduce(into: firstRect) { $0.union($1) }
//
//        scrollRectToVisible(unionRect, animated: true)
//    }
//}

extension UIScrollView {
    func scroll(to view: UIView) {
        let rect = convert(view.frame.offsetBy(dx: 0, dy: 8), to: self)
        scrollRectToVisible(rect, animated: true)
    }

    func scroll(to views: [UIView]) {
        if views.isEmpty {
            return
        }

        let rects: [CGRect] = views.map { convert($0.frame, to: self) }

        /// check for isEmpty is above
        let firstRect = rects[0]
        let unionRect: CGRect = rects.dropFirst().reduce(into: firstRect) { $0.union($1) }

        scrollRectToVisible(unionRect, animated: true)
    }
}






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
