import UIKit

/// another name IntrinsicTextView
final class ResizableTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isScrollEnabled = false
        
        /// to remove insets
        /// https://stackoverflow.com/a/42333832/5893286
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return text.isEmpty ? .zero : super.intrinsicContentSize
    }
    
}
