import UIKit

@available(tvOS, unavailable)
@available(macCatalyst, unavailable)
final public class KeyboardLayoutConstraint: NSLayoutConstraint {
    
    /// used class var bcz instance var = 0
    static let tabBarHeight: CGFloat = 49
    
    @IBInspectable public var keyboardInset: CGFloat = 1000
    @IBInspectable public var initialInset: CGFloat = 0
    @IBInspectable public var isTabBar: Bool = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShowNotification(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        constant = keyboardFrame.size.height + keyboardInset
        if isTabBar {
            constant -= KeyboardLayoutConstraint.tabBarHeight
        }
        // TODO: Device.isIphoneX
//        if Device.isIphoneX {
//            // TODO: safeAreaInsets.bottom
//            constant -= 34
//        }
        layoutIfNeededWithAnimation()
    }
    
    @objc private func keyboardWillHideNotification(_ notification: NSNotification) {
        constant = initialInset
        layoutIfNeededWithAnimation()
    }
    
    private func layoutIfNeededWithAnimation() {
        /// 1. view.window or view.superview ???
        /// 2. maybe there is a better way to update layout
        if let view = secondItem as? UIView, let superview = view.superview {
            superview.layoutIfNeeded()
        } else if let view = firstItem as? UIView, let superview = view.superview {
            superview.layoutIfNeeded()
        }
    }
}
