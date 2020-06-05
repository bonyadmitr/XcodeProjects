import UIKit

/// inspired  https://github.com/MoZhouqi/KMPlaceholderTextView
class PlaceholderTextView: UITextView {
    
    private let systemPlaceholderColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
        }
    }()
    
    let placeholderLabel = UILabel()
    
    var placeholderColor: UIColor {
        get { return placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }
    
    var placeholder: String {
        get { return placeholderLabel.text ?? "" }
        set { placeholderLabel.text = newValue }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            updatePlaceholderConstraints()
        }
    }
    
    private var placeholderConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        /// font == nil from init frame
        font = UIFont.preferredFont(forTextStyle: .body)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupSelf()
        setupPlaceholderLabel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    //deinit {
    //    NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    //}
    
    private func setupSelf() {
        adjustsFontForContentSizeCategory = true
        removePadding()
        placeholderColor = systemPlaceholderColor
    }
    
    private func setupPlaceholderLabel() {
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.adjustsFontForContentSizeCategory = true
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        updatePlaceholderConstraints()
    }
    
    private func updatePlaceholderConstraints() {
        
        /// guard for textContainerInset change after init()
        if placeholderLabel.superview == nil {
            return
        }
        
        removeConstraints(placeholderConstraints)
        
        // TODO: check for RTL languages
        let leftConstant = textContainerInset.left + textContainer.lineFragmentPadding
        let rightConstant = textContainerInset.right + textContainer.lineFragmentPadding
        let topConstant = textContainerInset.top
        let bottomConstant = textContainerInset.bottom
        
        placeholderConstraints = [
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftConstant),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightConstant),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant)
        ]
        
        addConstraints(placeholderConstraints)
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
}

extension UITextView {

    func removePadding() {
        /// remove insets https://stackoverflow.com/a/42333832/5893286
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
}

import UIKit

class ResizableTextView: UITextView {
    
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
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}

final class ResizableEmptiableTextView: ResizableTextView {
    override var intrinsicContentSize: CGSize {
        return text.isEmpty ? .zero : super.intrinsicContentSize
    }
}

class ResizablePlaceholderTextView: PlaceholderTextView {
    
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
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        /// max text size
        //if placeholderLabel.intrinsicContentSize.height > super.intrinsicContentSize.height {
        //    return placeholderLabel.intrinsicContentSize
        //} else {
        //    return super.intrinsicContentSize
        //}
        
        /// visible text size
        if text.isEmpty, placeholderLabel.intrinsicContentSize.height > super.intrinsicContentSize.height {
            return placeholderLabel.intrinsicContentSize
        } else {
            return super.intrinsicContentSize
        }
        
    }
}

class UnderlineResizablePlaceholderTextView: ResizablePlaceholderTextView {
    
    var underlineHeight: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    
    var underlineOffset: CGFloat = 4 {
        didSet { setNeedsDisplay() }
    }
    
    var underlineColor = UIColor.black {
        didSet {
            underlineLayer.backgroundColor = underlineColor.cgColor
        }
    }
    
    private let underlineLayer = CALayer()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.addSublayer(underlineLayer)
        underlineLayer.backgroundColor = underlineColor.cgColor
        textContainerInset.bottom = underlineOffset
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CALayer.performWithoutAnimation {
            underlineLayer.frame = CGRect(x: 0.0,
                                          y: frame.height - underlineHeight,
                                          width: frame.width,
                                          height: underlineHeight);
        }
        
    }
}

extension CALayer {
    
    /// source https://stackoverflow.com/a/33961937/5893286
    static func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}

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

// TODO: InsetsTextField https://stackoverflow.com/a/3969703/5893286

