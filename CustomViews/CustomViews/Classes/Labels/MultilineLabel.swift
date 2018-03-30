import UIKit

/// A subclass of UILabel that automatically wraps text to width of its own frame.
/// May be used with AutoLayout without providing a preferredMaxLayoutWidth.
/// IMPORTANT: Do not assign a height constraint to MultilineLabel
open class MultilineLabel: UILabel {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        preferredMaxLayoutWidth = bounds.size.width
    }
}
