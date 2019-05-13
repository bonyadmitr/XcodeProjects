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
    }
    
    let textView = UITextView()
    
    private lazy var toolBar2: UIToolbar = {
        
        let textBarItem = UIBarButtonItem(customView: textView)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([textBarItem], animated: false)
        //toolBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        
        return toolBar
    }()
    
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
