import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someTextView: UITextView!
//    @IBOutlet private weak var someLabel: UILabel!
//    @IBOutlet private weak var someLabel: LinkLabel!
    @IBOutlet private weak var someLabel: TapableLabel!
    
    @IBAction private func someButton(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        someLabel.isUserInteractionEnabled = true
//        someLabel.lineBreakMode = .byWordWrapping
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
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        
//        let linkText1 = "consectetaur\u{a0}cillium"
        let linkText1 = "consectetaur cillium".replacingOccurrences(of: " ", with: "\u{a0}")
//        let linkText1 = "consectetaur cillium"
        
        
        let allText = NSMutableAttributedString(string: "Lorem ipsum dolor sit er elit lamet, \(linkText1) adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", attributes:
            [.font: UIFont.systemFont(ofSize: 16),
             .paragraphStyle: paragraphStyle,
             .foregroundColor: UIColor.darkGray])
        
        
        
        /// without "rawValue" in NSUnderlineStyle.single.rawValue will be crash
        /// don't use NSUnderlineStyle.single without rawValue
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        
//        let strTC = "terms and conditions"
//        let strPP = "privacy policy"
        
        
        let rangeLink1 = allText.mutableString.range(of: linkText1)
        allText.addAttributes(linkAttributes, range: rangeLink1)
//        allText.addAttributes([.link: "some_url_1vfhvdhfhjsdjfhsdjhf"], range: rangeLink1)
        
        someLabel.attributedText = allText
        
//        someLabel.addLink(linkText1, withURL: "some_url_1")
        someLabel.addLink(at: rangeLink1, withURL: "some_url_1")
        someLabel.delegate = self
    }
}

extension ViewController: TapableLabelDelegate {
    func tapableLabel(_ label: TapableLabel, didTapUrl url: String, atRange range: NSRange) {
        print("- taped at \(url)")
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
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        setLink(for: touches)
    }
    
    private func setLink(for touches: Set<UITouch>) {
        if let pt = touches.first?.location(in: self), let (characterRange, _) = link(at: pt) {
            let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
            selectedBackgroundView.frame = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer).insetBy(dx: -3, dy: -3)
            selectedBackgroundView.isHidden = false
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
    
    public weak var delegate: TapableLabelDelegate?
    
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: .zero)
    private var textStorage: NSTextStorage?
    private var links: [String: NSRange] = [:]
    
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
        
        guard let touchLocation = touches.first?.location(in: self) else {
            assertionFailure()
            return
        }
        animateLink(for: touchLocation)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touchLocation = touches.first?.location(in: self) else {
            assertionFailure()
            return
        }
        animateLink(for: touchLocation)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateLinkBackIfNeed()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateLinkBackIfNeed()
        
        guard let touchLocation = touches.first?.location(in: self) else {
            assertionFailure()
            return
        }
        
        // TODO: check
        if textContainer.size != bounds.size {
            assertionFailure()
            textContainer.size = bounds.size
        }
        
        /// #1
        let indexOfCharacter = layoutManager.glyphIndex(for: touchLocation, in: textContainer)
        /// #2
        //let indexOfCharacter = layoutManager.characterIndex(for: touchLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for (urlString, range) in links {
            if NSLocationInRange(indexOfCharacter, range) {
                delegate?.tapableLabel(self, didTapUrl: urlString, atRange: range)
            }
        }
    }
    
    private func animateLinkBackIfNeed() {
        if self.backupAttributedText != nil {
            self.attributedText = self.backupAttributedText
            self.backupAttributedText = nil
            isLinkHighlighted = false
        }
    }
    
    private func animateLink(for touchLocation: CGPoint) {
        let indexOfCharacter = layoutManager.glyphIndex(for: touchLocation, in: textContainer)
        
        for (_, range) in links {
            if NSLocationInRange(indexOfCharacter, range) {
                guard !isLinkHighlighted else {
                    return
                }
                self.backupAttributedText = self.attributedText
                let attributedString = NSMutableAttributedString(attributedString: self.attributedText!)
                attributedString.addAttributes([.foregroundColor: UIColor.red], range: range)
                
                /// can be animated
                /// UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.attributedText = attributedString
                isLinkHighlighted = true
                
            } else {
                animateLinkBackIfNeed()
            }
        }
    }
    
    // MARK: - public
    
    public func addLink(at range: NSRange, withURL url: String) {
        links[url] = range
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
        
        links[url] = range
    }
}
