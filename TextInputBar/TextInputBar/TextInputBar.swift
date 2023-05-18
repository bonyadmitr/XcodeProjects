//
//  TextInputBar.swift
//  TextInputBar
//
//  Created by Yaroslav Bondar on 11.04.2023.
//

import UIKit

final class TextInputBar: UIView, NibInit {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playButton: UIButton!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
////        autoresizingMask = .flexibleHeight
//
//    }
    
    var onSizeChange: (() -> Void)?
    
    private let font = UIFont.systemFont(ofSize: 16, weight: .regular)
    private let maxNumberOfLines: CGFloat = 6
    
    private lazy var maxHeight: CGFloat = {
        return ceil(font.lineHeight * maxNumberOfLines + textView.textContainerInset.top + textView.textContainerInset.bottom)// + 8 + 8
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.font = font
        placeholderLabel.font = font
        
        /// to remove insets https://stackoverflow.com/a/42333832/5893286
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        textView.delegate = self
        
        /// to set height first time
        textViewDidChange(textView)
        
        SpeachManager.shared.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            self.textView.text = text
            self.textViewDidChange(self.textView)
            
            /// move caret to the end on voice recognition
            self.textView.scrollRangeToVisible(NSRange(location: text.count - 1, length: 1))
        }
        SpeachManager.shared.onAutoStop = { [weak self] in
            self?.playButton.isSelected = false
        }
        
    }
    
    private var lastCalculatedHeight: CGFloat = -1
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: bounds.width, height: heightConstraint.constant + 8 + 8) //8 + 8 - top and bottom insets
    }
    
    @IBAction private func onMic(_ sender: UIButton) {
        
        
        SpeachManager.shared.requestSpeechAuthorization { result in
            switch result {
                
            case .authorized:
                if sender.isSelected {
                    SpeachManager.shared.stop()
                } else {
                    SpeachManager.shared.start()
                }
                sender.isSelected.toggle()
            case .denied(let deniedType):
                
                let title: String
                switch deniedType {
                case .voiceRecord:
                    title = "voiceRecord denied "
                case .speechRecognizer:
                    title = "speechRecognizer denied "
                }
                
                // TODO: do UI
                let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                alertVC.addAction(.init(title: "OK", style: .cancel))
                alertVC.addAction(.init(title: "Settings", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true)
            }
//            if isAuthorized {
//                SpeachManager.shared.start()
////                if sender.isHighlighted {
////                    SpeachManager.shared.start()
////                } else {
////                    SpeachManager.shared.stop()
////                }
//                
//            } else {
                
//                
//                print("SpeachManager NOT Authorized")
//            }
        }
        
        
        
    }
}

extension TextInputBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let attributes = [NSAttributedString.Key.font: font]
        let boundingSize = CGSize(width: textView.frame.width - textView.textContainerInset.left - textView.textContainerInset.right, height: .greatestFiniteMagnitude)
        let textSize = textView.text.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let needHeight: CGFloat = ceil(textSize.height) + textView.textContainerInset.top + textView.textContainerInset.bottom
        
        let isMoreThanMax = needHeight > maxHeight
        textView.isScrollEnabled = isMoreThanMax
        
        let height: CGFloat = (isMoreThanMax ? maxHeight : needHeight)
        
        if heightConstraint.constant != height {
            heightConstraint.constant = height
            
            invalidateIntrinsicContentSize()
            layoutIfNeeded()
            onSizeChange?()
        }
        
        
        
        
//        let attributes = [NSAttributedString.Key.font: font]
//        let boundingSize = CGSize(width: textView.frame.width - textView.textContainerInset.left - textView.textContainerInset.right, height: .greatestFiniteMagnitude)
//        let textSize = textView.text.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//        let needHeight = ceil(textSize.height) + textView.textContainerInset.top + textView.textContainerInset.bottom + 8 + 8
//        print("needHeight: \(needHeight)")
//
//
//
//        //        var contentSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
//        //        let needHeight = contentSize.height + 8 + 8
//
//        let isMoreThanMax = needHeight > maxHeight
//        let height: CGFloat = isMoreThanMax ? maxHeight : needHeight
//
//        if lastCalculatedHeight != height {
//            lastCalculatedHeight = height
//            textView.isScrollEnabled = isMoreThanMax
//            invalidateIntrinsicContentSize()
//        }
    }
}



protocol NibInit {}

extension NibInit where Self: UIView {
    static func initFromNib() -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            assertionFailure("check all IBOtlets")
            return Self()
        }
        return view
    }
}


//class FlexibleTextView: UITextView {
//    // limit the height of expansion per intrinsicContentSize
//    var maxHeight: CGFloat = 0.0
//
//    private let placeholderLabel: UITextView = {
//        let tv = UITextView()
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .clear
//        tv.isScrollEnabled = false
//        tv.isUserInteractionEnabled = false
//        tv.textColor = UIColor.gray
//        return tv
//    }()
//    var placeholder: String? {
//        get {
//            return placeholderLabel.text
//        }
//        set {
//            placeholderLabel.text = newValue
//        }
//    }
//
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        isScrollEnabled = false
//        autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
//        placeholderLabel.font = font
//        addSubview(placeholderLabel)
//
//        NSLayoutConstraint.activate([
//            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            placeholderLabel.topAnchor.constraint(equalTo: topAnchor),
//            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//    }
//
//    override var text: String! {
//        didSet {
//            invalidateIntrinsicContentSize()
//            placeholderLabel.isHidden = !text.isEmpty
//        }
//    }
//
//    override var font: UIFont? {
//        didSet {
//            placeholderLabel.font = font
//            invalidateIntrinsicContentSize()
//        }
//    }
class RoundedCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 30 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
