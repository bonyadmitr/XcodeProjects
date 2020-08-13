import UIKit

@available(tvOS, unavailable)
@available(macCatalyst, unavailable)
final public class KeyboardLayoutConstraint: NSLayoutConstraint {
    
    /// used class var bcz instance var = 0
    // TODO: tabBarHeight for landscape. there is a bug
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
        
        /// 49/32
        /// iPhone x  83/70
        if isTabBar {
            
            if Device.isIphoneX {
                if UIApplication.shared.statusBarOrientation.isLandscape {
                    constant -=  70
                } else {
                    constant -= 83
                }
            } else {
                if UIApplication.shared.statusBarOrientation.isLandscape {
                    constant -= 32
                } else {
                    constant -= 49
                }
            }
            

            
            
//            constant -= KeyboardLayoutConstraint.tabBarHeight
        } else {
            if Device.isIphoneX {
                // TODO: safeAreaInsets.bottom
                constant -= 34
            }
        }
        
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

private enum Device {
    
    /// https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
    static var isIphoneX: Bool {
        return (UIDevice.current.userInterfaceIdiom == .phone) && (UIScreen.main.bounds.height >= 812)
    }
}
