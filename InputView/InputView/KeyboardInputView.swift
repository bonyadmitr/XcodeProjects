import UIKit

// TODO: add another methods from UITextInputTraits
final class KeyboardInputView: InputView, UITextInputTraits {
    
    var text = ""
    
    /// keyboardType works without adopting UITextInputTraits
    var keyboardType: UIKeyboardType = .default
    
    var textDidChange: ((String) -> Void)?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addTapGestureToOpenInputView()
    }
}

extension KeyboardInputView: UIKeyInput {
    
    var hasText: Bool {
        return !text.isEmpty
    }
    
    func insertText(_ text: String) {
        self.text.append(text)
        textDidChange?(self.text)
    }
    
    func deleteBackward() {
        text.removeLast()
        textDidChange?(self.text)
    }
}
