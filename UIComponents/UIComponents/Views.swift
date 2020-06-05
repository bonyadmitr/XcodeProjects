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


/// source https://github.com/Rightpoint/Swiftilities/issues/88
// These let you start a touch on a button that's inside a scroll view,
// and then if you start dragging, it cancels the touch on the button
// and lets you scroll instead. Without these scroll view subclasses,
// buttons in scroll views will eat touches that start in them, which
// prevents scrolling and makes the app feel broken.
//
// The UITextInput exception is for cases where you have a text field
// or a label in a scroll view. If you press and hold there, you want
// to get the text editing magnifier cursor, instead of canceling the
// touch in the text input element.
class ControlContainableScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // TODO: check needs. add to others if need
        /// Hack to allow buttons to show highlight state immediately on touch https://stackoverflow.com/a/19299451/5893286
        
        /// tableview hack https://stackoverflow.com/a/33743183/5893286
        
        /// maybe don't need this https://stackoverflow.com/a/45240170/5893286
        delaysContentTouches = false
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl && !(view is UITextInput) {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }

}

class ControlContainableTableView: UITableView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl && !(view is UITextInput) {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }

}

class ControlContainableCollectionView: UICollectionView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl && !(view is UITextInput) {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }

}
