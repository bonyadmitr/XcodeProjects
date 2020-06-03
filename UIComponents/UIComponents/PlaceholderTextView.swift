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
