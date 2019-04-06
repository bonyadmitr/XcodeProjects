import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someTextView: UITextView! {
        willSet {
            newValue.isEditable = false
            newValue.isScrollEnabled = false
            newValue.delaysContentTouches = false
            newValue.dataDetectorTypes = .link
            
            /// don't need, but maybe will increase performance
            newValue.showsVerticalScrollIndicator = false
            newValue.showsHorizontalScrollIndicator = false
            newValue.alwaysBounceVertical = false
            newValue.alwaysBounceHorizontal = false
        }
    }
    
    @IBOutlet weak var htmlTextView: UITextView! {
        willSet {
            newValue.isEditable = false
            newValue.delaysContentTouches = false
            newValue.dataDetectorTypes = .link
        }
    }
    
    @IBOutlet private weak var someLabel: TapableLabel!
    
    @IBAction private func someButton(_ sender: UIBarButtonItem) {
        
    }
    
    private let termsAndConditionsUrl = "terms_and_conditions"
    private let privacyPolicyUrl = "privacy_policy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabelAndTextViewByAttributedText()
        setupHtmlTextView()
    }
    
    private func setupLabelAndTextViewByAttributedText() {
        /// don't use label textAlignment, link detectors will be broken.
        /// use NSMutableParagraphStyle in attributes of NSMutableAttributedString.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 1
        
        let localizedFullText = "Lorem ipsum dolor sit er elit lamet, %1$@ adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. %2$@ Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        /// use "\u{a0}" instead of " "(space) if you don't want line breaks in the links
        //let privacyPolicyText = "privacy\u{a0}policy"
        //let privacyPolicyText = "privacy policy".replacingOccurrences(of: " ", with: "\u{a0}")
        
        let termsAndConditionsText = "terms and conditions"
        let privacyPolicyText = "privacy policy"
        
        let fullText = String(format: localizedFullText, arguments: [termsAndConditionsText, privacyPolicyText])
        
        let attributedFullText = NSMutableAttributedString(string: fullText, attributes:
            [.font: UIFont.systemFont(ofSize: 16),
             .paragraphStyle: paragraphStyle,
             .foregroundColor: UIColor.black])
        
        /// default
        someLabel.highlightedLinkAttributes = [.foregroundColor: UIColor.purple]
        
        /// without "rawValue" in NSUnderlineStyle.single.rawValue will be crash
        /// don't use NSUnderlineStyle.single without rawValue
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        func setLinkAttributes(for text: String, url: String) {
            let range = attributedFullText.mutableString.range(of: text)
            attributedFullText.addAttributes(linkAttributes, range: range)
            someLabel.addLink(at: range, withURL: url)
        }
        
        /// for can use any stringID in urls.
        /// don't forget to check them in TapableLabelDelegate "... didTapAt" func
        setLinkAttributes(for: termsAndConditionsText, url: termsAndConditionsUrl)
        setLinkAttributes(for: privacyPolicyText, url: privacyPolicyUrl)
        
        someLabel.attributedText = attributedFullText
        someLabel.delegate = self
        
        
        
        
        
        // MARK: - Additional setup for UITextView
        
        /// need only for UITextView to detect links
        func setLinkAttributes2(for text: String, url: String) {
            let range = attributedFullText.mutableString.range(of: text)
            attributedFullText.addAttributes([.link: url], range: range)
        }
        
        setLinkAttributes2(for: termsAndConditionsText, url: termsAndConditionsUrl)
        setLinkAttributes2(for: privacyPolicyText, url: privacyPolicyUrl)
        
        someTextView.attributedText = attributedFullText
        
        /// "attributedFullText.addAttributes(linkAttributes, range: range)" will not work for UITextView
        /// use only ".linkTextAttributes"
        someTextView.linkTextAttributes = linkAttributes
        
        /// there is small delay for UITextView touch on links.
        /// also links can be long touched and dragged.
        ///
        /// action called on touch in event.
        /// cannot be cancled.
        /// there is the rounded background highlight of link on touch.
        ///
        /// any text is selectable by default.
        /// to disable read: https://stackoverflow.com/q/27988279/5893286
        /// or try (didn't tested): https://stackoverflow.com/a/50772325/5893286
        someTextView.delegate = self
    }
    
    private func setupHtmlTextView() {
        
        /// https://stackoverflow.com/q/50969015/5893286
        let htmlString = "<body style='padding-left:50px'><h1>Hello World</h1><div><a href=https://apple.com/offer/samsung-faq/>Click Here</a></div><p>This is a sample text</p><pre>This is also sample pre text</pre></body>"
        
        guard let data = htmlString.data(using: .utf8) else {
            assertionFailure()
            return
        }
        do {
            let attributedString = try NSAttributedString(data: data, options:
                [.documentType: NSAttributedString.DocumentType.html,
                 .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            htmlTextView.attributedText = attributedString
        } catch {
            assertionFailure()
        }
    }
}

// MARK: - TapableLabelDelegate
extension ViewController: TapableLabelDelegate {
    func tapableLabel(_ label: TapableLabel, didTapAt url: String, in range: NSRange) {
        switch url {
        case termsAndConditionsUrl:
            print("open termsAndConditions")
        case privacyPolicyUrl:
            print("open privacyPolicy")
        default:
            assertionFailure("should never be called")
        }
    }
}

// MARK: - UITextViewDelegate
extension ViewController: UITextViewDelegate {
    
    /// can be used this method. it will be called only for iOS 10+ if implemented both methods
    //@available(iOS 10.0, *)
    //func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        switch URL.absoluteString {
        case termsAndConditionsUrl:
            print("textView open termsAndConditions")
        case privacyPolicyUrl:
            print("textView open privacyPolicy")
        default:
            assertionFailure("should never be called")
        }
        
        /// if "return true" will be warning in console "Could not find any actions for..."
        return false
    }
}

import UIKit

public protocol TapableLabelDelegate: class {
    func tapableLabel(_ label: TapableLabel, didTapAt url: String, in range: NSRange)
}

// TODO: add background highlight like UITextView click with line breaks
/// question: https://stackoverflow.com/q/1256887/5893286
/// answer that upgraded: https://stackoverflow.com/a/53407849/5893286
public class TapableLabel: UILabel {
    
    /// defailt is [NSAttributedString.Key.foregroundColor: UIColor.purple]
    public var highlightedLinkAttributes = [NSAttributedString.Key.foregroundColor: UIColor.purple]
    
    public weak var delegate: TapableLabelDelegate?
    
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: .zero)
    private var textStorage: NSTextStorage?
    private var rangesByLinkUrls: [String: NSRange] = [:]
    
    private var isLinkHighlighted = false
    private var backupAttributedText: NSAttributedString?
    
    public override var attributedText: NSAttributedString? {
        didSet {
            setupTextStorage()
        }
    }
    
    public override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    public override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    /// #1
    public override var bounds: CGRect {
        didSet {
            textContainer.size = bounds.size
        }
    }
    /// #2
    //public override func layoutSubviews() {
    //    super.layoutSubviews()
    //    textContainer.size = bounds.size
    //}
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines  = numberOfLines
        
        layoutManager.addTextContainer(textContainer)
    }
    
    private func setupTextStorage() {
        let textStorage: NSTextStorage
        if let attributedText = attributedText {
            textStorage = NSTextStorage(attributedString: attributedText)
        } else {
            textStorage = NSTextStorage()
        }
        textStorage.addLayoutManager(layoutManager)
        self.textStorage = textStorage
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightLinkIfNeed(for: touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        highlightLinkIfNeed(for: touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        unhighlightLinkIfNeed()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unhighlightLinkIfNeed()
        
        guard let touchLocation = touches.first?.location(in: self) else {
            assertionFailure("touch will be always inside self")
            return
        }
        
        // TODO: check. delete if never called
        if textContainer.size != bounds.size {
            assertionFailure()
            textContainer.size = bounds.size
        }
        
        /// #1
        let indexOfCharacter = layoutManager.glyphIndex(for: touchLocation, in: textContainer)
        /// #2
        //let indexOfCharacter = layoutManager.characterIndex(for: touchLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for (urlString, range) in rangesByLinkUrls {
            if NSLocationInRange(indexOfCharacter, range) {
                delegate?.tapableLabel(self, didTapAt: urlString, in: range)
            }
        }
    }
    
    private func unhighlightLinkIfNeed() {
        if backupAttributedText != nil {
            attributedText = backupAttributedText
            backupAttributedText = nil
            isLinkHighlighted = false
        }
    }
    
    private func highlightLinkIfNeed(for touches: Set<UITouch>) {
        
        guard let touchLocation = touches.first?.location(in: self) else {
            assertionFailure("touch will be always inside self")
            return
        }
        
        let indexOfCharacter = layoutManager.glyphIndex(for: touchLocation, in: textContainer)
        
        guard let touchedRangeByLinkUrl = rangesByLinkUrls.first (where: { (_, range) in
            NSLocationInRange(indexOfCharacter, range)
        }) else {
            unhighlightLinkIfNeed()
            return
        }
        
        guard !isLinkHighlighted else {
            return
        }
        
        let touchedRange = touchedRangeByLinkUrl.value
        self.backupAttributedText = self.attributedText
        
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        attributedString.addAttributes(highlightedLinkAttributes, range: touchedRange)
        
        /// can be animated
        /// UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
        self.attributedText = attributedString
        
        isLinkHighlighted = true
    }
    
    // MARK: - public
    
    public func addLink(at range: NSRange, withURL url: String) {
        rangesByLinkUrls[url] = range
    }
    
    public func addLink(_ text: String, withURL url: String) {
        guard let theText = attributedText?.string as NSString? else {
            assertionFailure("system bug")
            return
        }
        
        let range = theText.range(of: text)
        
        guard range.location != NSNotFound else {
            assertionFailure("text didn't found in attributedText")
            return
        }
        
        rangesByLinkUrls[url] = range
    }
}
