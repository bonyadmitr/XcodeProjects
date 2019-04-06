import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someTextView: UITextView!
    @IBOutlet private weak var someLabel: LinkLabel!
//    @IBOutlet private weak var someLabel: TapableLabel!
    
    @IBAction private func someButton(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        someLabel.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel))
//        someLabel.addGestureRecognizer(tapGesture)
        
        
        
        
//        etkTextView.linkTextAttributes = [
//            NSAttributedStringKey.foregroundColor.rawValue: UIColor.lrTealishTwo,
//            NSAttributedStringKey.underlineColor.rawValue: UIColor.lrTealishTwo,
//            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue
//        ]
//
//        let baseText = NSMutableAttributedString(string: TextConstants.termsAndUseEtkCheckbox,
//                                                 attributes: [.font: UIFont.TurkcellSaturaRegFont(size: 12),
//                                                              .foregroundColor: ColorConstants.darkText])
//
//        let rangeLink1 = baseText.mutableString.range(of: TextConstants.termsAndUseEtkLinkTurkcellAndGroupCompanies)
//        baseText.addAttributes([.link: TextConstants.NotLocalized.termsAndUseEtkLinkTurkcellAndGroupCompanies], range: rangeLink1)
//
//        let rangeLink2 = baseText.mutableString.range(of: TextConstants.termsAndUseEtkLinkCommercialEmailMessages)
//        baseText.addAttributes([.link: TextConstants.NotLocalized.termsAndUseEtkLinkCommercialEmailMessages], range: rangeLink2)
//
//        etkTextView.attributedText = baseText
        
        
//        private func getParagraphStyle() -> NSMutableParagraphStyle {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 2
//            paragraphStyle.alignment = .center
//            return paragraphStyle
//        }
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 3
//        errorLabel.attributedText = NSAttributedString(string: withText, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        
        
        
        let allText = NSMutableAttributedString(string: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")
        
        /// without "rawValue" in NSUnderlineStyle.single.rawValue will be crash
        /// don't use NSUnderlineStyle.single without rawValue
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                             .font: UIFont.systemFont(ofSize: 14)]
        
        let linkText1 = "consectetaur cillium"
        let rangeLink1 = allText.mutableString.range(of: linkText1)
        allText.addAttributes(linkAttributes, range: rangeLink1)
        allText.addAttributes([.link: "some_url_1vfhvdhfhjsdjfhsdjhf"], range: rangeLink1)
        someLabel.attributedText = allText
        
        //someLabel.addLink(linkText1, withURL: "some_url_1")
//        someLabel.addLink(at: rangeLink1, withURL: "some_url_1")
//        someLabel.delegate = self
    }
    
    @objc private func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = someLabel.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "consectetaur cillium"),
            recognizer.didTapAttributedTextInLabel(label: someLabel, inRange: NSRange(range, in: text)) {
//            goToTermsAndConditions()
            print("1")
        } else if let range = text.range(of: "minim veniam"),
            recognizer.didTapAttributedTextInLabel(label: someLabel, inRange: NSRange(range, in: text)) {
            print("2")
//            goToPrivacyPolicy()
        }
    }
}

extension ViewController: TapableLabelDelegate {
    func tapableLabel(_ label: TapableLabel, didTapUrl url: String, atRange range: NSRange) {
        print("- taped at \(url)")
    }
}

/// https://stackoverflow.com/a/47140975/5893286
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

class AELinkedClickableUILabel: UILabel {
    
    typealias YourCompletion = () -> Void
    
    var linkedRange: NSRange!
    var completion: YourCompletion?
    
    @objc func linkClicked(_ sender: UITapGestureRecognizer) {
        
        if let completionBlock = completion {
            
            let textView = UITextView(frame: self.frame)
            textView.text = self.text
            textView.attributedText = self.attributedText
            let index = textView.layoutManager.characterIndex(for: sender.location(in: self),
                                                              in: textView.textContainer,
                                                              fractionOfDistanceBetweenInsertionPoints: nil)
            
            if linkedRange.lowerBound <= index && linkedRange.upperBound >= index {
                
                completionBlock()
            }
        }
    }
    
    /**
     *  This method will be used to set an attributed text specifying the linked text with a
     *  handler when the link is clicked
     */
    public func setLinkedTextWithHandler(text:String, link: String, handler: @escaping ()->()) -> Bool {
        
        let attributextText = NSMutableAttributedString(string: text)
        let foundRange = attributextText.mutableString.range(of: link)
        
        if foundRange.location != NSNotFound {
            self.linkedRange = foundRange
            self.completion = handler
            attributextText.addAttribute(NSAttributedString.Key.link, value: text, range: foundRange)
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkClicked)))
            return true
        }
        return false
    }
}

/**
You must set fonts in your NSAttributedStrings
You can only use NSAttributedStrings!
You must ensure your links cannot wrap (use non breaking spaces: "\u{a0}")
You cannot change the lineBreakMode or numberOfLines after setting the text
You create links by adding attributes with .link keys

*/
/// https://stackoverflow.com/a/47192154/5893286
public class LinkLabel: UILabel {
    
    private var storage: NSTextStorage?
    private let textContainer = NSTextContainer()
    private let layoutManager = NSLayoutManager()
    private var selectedBackgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        textContainer.layoutManager = layoutManager
        isUserInteractionEnabled = true
        selectedBackgroundView.isHidden = true
        selectedBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3333)
        selectedBackgroundView.layer.cornerRadius = 4
        addSubview(selectedBackgroundView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = frame.size
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setLink(for: touches)
    }
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
//        let locationOfTouchInLabel = self.location(in: label)
//        let textBoundingBox = layoutManager.usedRect(for: textContainer)
//        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
//        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
//        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//        return NSLocationInRange(indexOfCharacter, targetRange)
        return true
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        setLink(for: touches)
    }
    
    private func setLink(for touches: Set<UITouch>) {
        if let pt = touches.first?.location(in: self), let (characterRange, _) = link(at: pt) {
            didTapAttributedTextInLabel(label: self, inRange: characterRange)
            
            
//            let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
//            selectedBackgroundView.frame = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer).insetBy(dx: -3, dy: -3)
//            selectedBackgroundView.isHidden = false
        } else {
            selectedBackgroundView.isHidden = true
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        selectedBackgroundView.isHidden = true
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        selectedBackgroundView.isHidden = true
        
        if let pt = touches.first?.location(in: self), let (_, url) = link(at: pt) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func link(at point: CGPoint) -> (NSRange, URL)? {
        let touchedGlyph = layoutManager.glyphIndex(for: point, in: textContainer)
        let touchedChar = layoutManager.characterIndexForGlyph(at: touchedGlyph)
        var range = NSRange()
        let attrs = attributedText!.attributes(at: touchedChar, effectiveRange: &range)
        if let urlstr = attrs[.link] as? String {
            return (range, URL(string: urlstr)!)
        } else {
            return nil
        }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
            textContainer.lineBreakMode = lineBreakMode
            if let txt = attributedText {
                let storage = NSTextStorage(attributedString: txt)
                storage.addLayoutManager(layoutManager)
                self.storage = storage
                layoutManager.textStorage = storage
                textContainer.size = frame.size
            }
        }
    }
}

import UIKit

public protocol TapableLabelDelegate: class {
    func tapableLabel(_ label: TapableLabel, didTapUrl url: String, atRange range: NSRange)
}

/// https://stackoverflow.com/a/53407849/5893286
public class TapableLabel: UILabel {
    
    private var links: [String: NSRange] = [:]
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: .zero)
    
    private var textStorage = NSTextStorage() {
        didSet {
            textStorage.addLayoutManager(layoutManager)
        }
    }
    
    public weak var delegate: TapableLabelDelegate?
    
    public override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
            } else {
                textStorage = NSTextStorage()
                links = [:]
            }
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    /// addLinks
    ///
    /// - Parameters:
    ///   - text: text of link
    ///   - url: link url string
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
        
        links[url] = range
    }
    
    public func addLink(at range: NSRange, withURL url: String) {
        links[url] = range
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines  = numberOfLines
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let locationOfTouch = touches.first?.location(in: self) else {
            return
        }
        
        textContainer.size = bounds.size
//        let indexOfCharacter = layoutManager.glyphIndex(for: locationOfTouch, in: textContainer)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouch, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        print("- indexOfCharacter", indexOfCharacter)
        for (urlString, range) in links {
            //if NSLocationInRange(indexOfCharacter, range), let url = URL(string: urlString) {
            if NSLocationInRange(indexOfCharacter, range) {
                delegate?.tapableLabel(self, didTapUrl: urlString, atRange: range)
            }
        }
    }}
