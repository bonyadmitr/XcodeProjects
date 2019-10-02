import UIKit

/// can be used UIControl
class InputView: UIView {
    
    private var customInputView: UIView?
    private var customInputAccessoryView: UIView?
    
    override var inputAccessoryView: UIView? {
        return customInputAccessoryView
    }
    
    override var inputView: UIView? {
        return customInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return inputView != nil
    }
    
    func set(inputView: UIView?, inputAccessoryView: UIView?) {
        customInputView = inputView
        customInputAccessoryView = inputAccessoryView
    }
    
    func addTapGestureToOpenInputView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openInputView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func openInputView() {
        assert(window != nil, "Never call becomeFirstResponder() on a view that is not part of an active view hierarchy")
        becomeFirstResponder()
    }
}
