import UIKit

final class ViewController: UIViewController {
    
    /// needs if "becomeFirstResponder()" is not used
//    override var canBecomeFirstResponder: Bool {
//        return view.canBecomeFirstResponder
//    }
//
//    override var inputAccessoryView: UIView? {
//        return view.inputAccessoryView
//    }
}

final class ChatView: UIView {
    
    @IBOutlet private weak var toolBar: UIToolbar!
    
    private var viewHasPerformedSubviewLayoutAtLeastOnce = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTapGestureToHideKeyboard()
        
        /// 271 is keyboard height with suggestions
        customInputView.frame = CGRect(x: 0, y: 0, width: 0, height: 271)
    }
    
    let textView = UITextView()
    
    private lazy var toolBar2: UIToolbar = {
        textView.frame.size.width = 100
        let textBarItem = UIBarButtonItem(customView: textView)
        let switchKeyboardBarItem = UIBarButtonItem(title: "K", style: .plain, target: self, action: #selector(switchKeyboard))
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [switchKeyboardBarItem, textBarItem]
        //toolBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        
        return toolBar
    }()
    
    private let customInputView = UIDatePicker()
    
    @objc private func switchKeyboard() {
        if textView.inputView == nil {
            textView.inputView = customInputView
        } else {
            textView.inputView = nil
        }
        textView.reloadInputViews()
    }
    
    override var canBecomeFirstResponder: Bool {
        return viewHasPerformedSubviewLayoutAtLeastOnce
    }
    
    override var inputAccessoryView: UIView {
        return toolBar2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// need to remove animation on appear for inputAccessoryView
        /// https://stackoverflow.com/a/52450073/5893286
        if viewHasPerformedSubviewLayoutAtLeastOnce == false {
            viewHasPerformedSubviewLayoutAtLeastOnce = true
            UIView.performWithoutAnimation {
                becomeFirstResponder()
            }
        }
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapGesture() {
        /// don't use "endEditing(true)" bcz it will close inputAccessoryView
        textView.resignFirstResponder()
    }
}
