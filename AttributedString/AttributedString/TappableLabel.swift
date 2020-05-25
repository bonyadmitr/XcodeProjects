import UIKit

public protocol TappableLabelDelegate: class {
    func tappableLabel(_ label: TappableLabel, didTapAt url: String, in range: NSRange)
}

/// another solution https://github.com/badoo/HyperLabel
/// question: https://stackoverflow.com/q/1256887/5893286
/// answer that upgraded: https://stackoverflow.com/a/53407849/5893286
public class TappableLabel: UILabel {
    
    /// defailt is [.foregroundColor: UIColor.purple]
    public var highlightedLinkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.purple]
    
    public weak var delegate: TappableLabelDelegate?
    
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
                delegate?.tappableLabel(self, didTapAt: urlString, in: range)
                
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
        
        guard let attributedText = attributedText else {
            assertionFailure("you should setup attributedText")
            return
        }
        
        let touchedRange = touchedRangeByLinkUrl.value
        self.backupAttributedText = self.attributedText
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.addAttributes(highlightedLinkAttributes, range: touchedRange)
        
        /// can be animated
        /// UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
        self.attributedText = attributedString
        
        isLinkHighlighted = true
        
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
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

extension TappableLabel {
    func setup(fullText: NSMutableAttributedString,
               urlsByLinks: [String: String],
               linkAttributes: [NSAttributedString.Key: Any]) {
        
        for (link, url) in urlsByLinks {
            let range = fullText.mutableString.range(of: link)
            fullText.addAttributes(linkAttributes, range: range)
            addLink(at: range, withURL: url)
        }
        
        attributedText = fullText
        
        /// for background usage:
        /// with async will not update label by highlighting.
        /// another solution is create fullText in DispatchQueue.main.async too.
        /// seems like it is a bug.
        /// tested on iOS 12.
        /// seems the same bug https://github.com/Cocoanetics/DTCoreText/issues/620
        //DispatchQueue.main.sync { [weak self] in
        //    self?.attributedText = fullText
        //}
    }
}
