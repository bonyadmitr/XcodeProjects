import UIKit

public protocol TapableLabelDelegate: class {
    func tapableLabel(_ label: TapableLabel, didTapAt url: String, in range: NSRange)
}

// TODO: add background highlight like UITextView click with line breaks
/// check links and hebrew project (CoreText)
/// https://stackoverflow.com/questions/21443625/core-text-calculate-letter-frame-in-ios/21497660#21497660
/// https://stackoverflow.com/questions/21764316/using-nslayoutmanager-to-calculate-frames-for-each-glyph

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
                
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
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
