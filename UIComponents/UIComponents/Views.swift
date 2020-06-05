import UIKit

class ResizableCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}


class ResizableTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

import UIKit

/// https://stackoverflow.com/a/21267507
final class TextInsetsLabel: UILabel {
    
    override var text: String? {
        didSet {
            sizeToFit()
        }
    }
    
    @IBInspectable var topBottom: CGSize = .zero {
        didSet {
            textInsets.bottom = topBottom.width
            textInsets.top = topBottom.height
        }
    }
    
    @IBInspectable var leftRight: CGSize = .zero {
        didSet {
            textInsets.left = leftRight.width
            textInsets.right = leftRight.height
        }
    }
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
}
class InsetsLabel: UILabel {
    
    var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var topBottom: CGSize = .zero {
        didSet {
            insets.bottom = topBottom.width
            insets.top = topBottom.height
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var leftRight: CGSize = .zero {
        didSet {
            insets.left = leftRight.width
            insets.right = leftRight.height
            setNeedsDisplay()
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size != .zero {
            size.width += insets.left + insets.right
            size.height += insets.top + insets.bottom
        }
        return size
    }
}

class InsetsButton: UIButton {
    
    var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var topBottom: CGSize = .zero {
        didSet {
            insets.bottom = topBottom.width
            insets.top = topBottom.height
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var leftRight: CGSize = .zero {
        didSet {
            insets.left = leftRight.width
            insets.right = leftRight.height
            setNeedsDisplay()
        }
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return super.titleRect(forContentRect: contentRect.inset(by: insets))
    }
    
    /// can be used
    //override func draw(_ rect: CGRect) {
    //    super.draw(UIEdgeInsetsInsetRect(rect, insets))
    //}
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size != .zero {
            size.width += insets.left + insets.right
            size.height += insets.top + insets.bottom
        }

        size.width = ceil(size.width)
        size.height = ceil(size.height)

        return size
    }
    
    
    /// another
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//
//        return CGSize(width: size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
//                      height: size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom)
//    }
}
