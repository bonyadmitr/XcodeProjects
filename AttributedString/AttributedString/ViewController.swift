import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var someTextView: UITextView! {
        willSet {
            newValue.isEditable = false
            newValue.isScrollEnabled = false
            newValue.delaysContentTouches = false
            newValue.dataDetectorTypes = .link
            
            /// https://stackoverflow.com/a/42333832/5893286
            newValue.textContainerInset = .zero
            newValue.textContainer.lineFragmentPadding = 0
            
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
        
        DispatchQueue.global().async { [weak self] in
            self?.setupLabelAndTextViewByAttributedText()
        }
        
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
        
        /// without "rawValue" in NSUnderlineStyle.single.rawValue will be crash
        /// don't use NSUnderlineStyle.single without rawValue
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue,
                                                             .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        /// for can use any stringID in urls.
        /// don't forget to check them in TapableLabelDelegate "... didTapAt" func
        someLabel.setup(fullText: attributedFullText,
                        urlsByLinks: [termsAndConditionsText: termsAndConditionsUrl,
                                      privacyPolicyText: privacyPolicyUrl],
                        linkAttributes: linkAttributes)
        
        /// default
        //someLabel.highlightedLinkAttributes = [.foregroundColor: UIColor.purple]
        
        someLabel.delegate = self
        
        
        
        
        
        // MARK: - Additional setup for UITextView
        
        /// need only for UITextView to detect links
        func setLinkAttributes2(for text: String, url: String) {
            let range = attributedFullText.mutableString.range(of: text)
            attributedFullText.addAttributes([.link: url], range: range)
        }
        
        setLinkAttributes2(for: termsAndConditionsText, url: termsAndConditionsUrl)
        setLinkAttributes2(for: privacyPolicyText, url: privacyPolicyUrl)
        
        DispatchQueue.main.async { [weak self] in
            self?.someTextView.attributedText = attributedFullText
            
            /// "attributedFullText.addAttributes(linkAttributes, range: range)" will not work for UITextView
            /// use only ".linkTextAttributes"
            self?.someTextView.linkTextAttributes = linkAttributes
            
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
            self?.someTextView.delegate = self
        }
    }
    
    private func setupHtmlTextView() {
        
        /// https://stackoverflow.com/q/50969015/5893286
        let htmlString = "<body style='padding-left:50px'><h1>Hello World</h1><div><a href=https://apple.com/offer/samsung-faq/>Click Here</a></div><p>This is a sample text</p><pre>This is also sample pre text</pre></body>"
        
        guard let data = htmlString.data(using: .utf8) else {
            assertionFailure()
            return
        }
        
        /// fixed black screen
        /// and error "AttributedString called within transaction"
        DispatchQueue.global().async {
            do {
                let attributedString = try NSAttributedString(data: data, options:
                    [.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                
                DispatchQueue.main.async {
                    self.htmlTextView.attributedText = attributedString
                }
            } catch {
                assertionFailure()
            }
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

extension TapableLabel {
    func setup(fullText: NSMutableAttributedString,
               urlsByLinks: [String: String],
               linkAttributes: [NSAttributedString.Key: Any]) {
        
        for (link, url) in urlsByLinks {
            let range = fullText.mutableString.range(of: link)
            fullText.addAttributes(linkAttributes, range: range)
            addLink(at: range, withURL: url)
        }
        
        /// with async will not update label by highlighting
        DispatchQueue.main.sync { [weak self] in
            self?.attributedText = fullText
        }
    }
}
