//
//  ViewController.swift
//  DynamicFont
//
//  Created by Bondar Yaroslav on 5/4/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// iOS 10 Attributed Text https://medium.com/livefront/practical-dynamic-type-part-3-attributed-text-65c39d8586c4

/// source https://stackoverflow.com/a/35357416/5893286
//let pointSize  = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
//let customFont = UIFont(name: "Chalkboard SE", size: pointSize)

//protocol DynamicFontable: UIContentSizeCategoryAdjusting {
//    var font: UIFont? { get set }
//}
//
//extension DynamicFontable {
//    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
//        self.font = font.dynamic(for: textStyle)
//        adjustsFontForContentSizeCategory = true
//    }
//}
//
//extension UILabel: DynamicFontable {}
//extension UITextField: DynamicFontable {}
//extension UITextView: DynamicFontable {}

/// https://stackoverflow.com/a/45907509/5893286
final class InstantPanGestureRecognizer: UIPanGestureRecognizer {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if state == .began {
            return
        }
        super.touchesBegan(touches, with: event)
        state = .began
    }

}

/// set font in .font property or in .attributedText attribute .font
final class TouchLabel: UILabel {
    
    var highlightedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.purple]
    var highlightedHandler: ((TouchLabel) -> Void)?
    var unhighlightedHandler: ((TouchLabel) -> Void)?
    var touchedUpInsideHandler: (() -> Void)?
    
    private var isLinkHighlighted = false
    private var backupAttributedText: NSAttributedString?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        adjustsFontForContentSizeCategory = true
        isUserInteractionEnabled = true
        textAlignment = .center
        numberOfLines = 0
        
        let panGesture = InstantPanGestureRecognizer(target: self, action: #selector(onPanGesture))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        
        guard bounds.contains(touchLocation) else {
            unhighlightIfNeed()
            return
        }
        
        if gesture.state == .ended {
            touchedUpInsideHandler?()
            unhighlightIfNeed()
            return
        }
        
        highlightIfNeed()
    }
    
    private func highlightIfNeed() {
        
        if isLinkHighlighted {
            return
        }
        
        isLinkHighlighted = true
        
        guard let attributedText = attributedText else {
            assertionFailure("you should setup attributedText")
            return
        }
        
        let range = NSRange(location: 0, length: attributedText.length)
        backupAttributedText = attributedText
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.addAttributes(highlightedAttributes, range: range)
        
        /// can be animated
        /// UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
        self.attributedText = attributedString
        
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
        
        highlightedHandler?(self)
    }
    
    private func unhighlightIfNeed() {
        if backupAttributedText != nil {
            attributedText = backupAttributedText
            backupAttributedText = nil
            isLinkHighlighted = false
            unhighlightedHandler?(self)
        }
    }
}

// TODO: best practices with fonts
// TODO: satisfy font from design with dynamic one
// TODO: in app font size setting like macOS telegram
extension UIFont {
    
    // TODO: add guard "is already dynamic" to prevent crash
    func dynamic() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
    
    func dynamic(for textStyle: UIFont.TextStyle) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: self)
    }
}

extension UILabel {
    
    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
    
}

extension UITextField {
    
    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
    
    func updateFontToDynamic(for textStyle: UIFont.TextStyle = .body) {
        font = font?.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
        
        // TODO: check
        //adjustsFontSizeToFitWidth = false
    }
}

extension UITextView {
    func setDynamicFont(font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
}


/// inspired https://dasdom.github.io/dynamic-type-in-uibuttons/
final class Button: UIButton {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let text = currentTitle
        setTitle(nil, for: state)
        setTitle(text, for: state)
    }

}

extension UIButton {

    /// inspired https://blog.kiprosh.com/dynamic-font-size-in-ios/
    func setDynamicFontSize() {
//        titleLabel?.font = titleLabel?.font.dynamic()
//        titleLabel?.adjustsFontForContentSizeCategory = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(setButtonDynamicFontSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    @objc private func setButtonDynamicFontSize() {
//        sizeToFit()
        
        let title = currentAttributedTitle
        
        titleLabel?.attributedText = title
//        setAttributedTitle(nil, for: state)
//        setAttributedTitle(title, for: state)
        
        
//        sizeToFit()
    }

}



class ViewController: UIViewController {
    
    let myButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let font = UIFont.systemFont(ofSize: 30)
        //let font = UIFont.preferredFont(forTextStyle: .body)
        
        let font = UIFont.systemFont(ofSize: 30).dynamic()
        
        let label1 = UILabel()
        label1.text = "Label 1"
        label1.font = font
        label1.adjustsFontForContentSizeCategory = true
        
        let button1 = UIButton(type: .system)
        button1.setTitle("Button 1", for: .normal)
        button1.setTitleColor(.label, for: .normal)
        button1.titleLabel?.font = font
        button1.titleLabel?.adjustsFontForContentSizeCategory = true
        
        
        let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.red,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .font: font]
        let attrTitle = NSMutableAttributedString(string: "Button 2", attributes: attributes)
        
        let button2 = UIButton(type: .system)
        
        //button2.setTitleColor(.label, for: .normal)
        button2.setAttributedTitle(attrTitle, for: .normal)
        button2.titleLabel?.attributedText = attrTitle
        button2.titleLabel?.font = font
        button2.titleLabel?.adjustsFontForContentSizeCategory = true
        button2.setDynamicFontSize()
        
        view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            button2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            button2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        ])
        
        
        /// https://stackoverflow.com/a/56826854/5893286
        
        let attributedText = NSAttributedString(string: "Press me", attributes: attributes)
        myButton.titleLabel?.attributedText = attributedText
        myButton.setAttributedTitle(myButton.titleLabel?.attributedText, for: .normal)
        myButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        let label2 = UILabel()
        label2.attributedText = NSAttributedString(string: "Label 2", attributes: attributes)
        label2.adjustsFontForContentSizeCategory = true
        
        let touchLabel = TouchLabel()
        //touchLabel.font = font
        //touchLabel.highlightedAttributes
        touchLabel.attributedText = NSAttributedString(string: "TouchLabel", attributes: attributes)
        touchLabel.touchedUpInsideHandler = {
            print("- click AttributedButton")
        }
        touchLabel.highlightedHandler = { button in
            button.backgroundColor = .gray
        }
        touchLabel.unhighlightedHandler = { button in
            button.backgroundColor = .clear
        }
        
        let textView1 = UITextView()
        textView1.font = font
        textView1.text = "UITextView 1"
        textView1.adjustsFontForContentSizeCategory = true
        //textView1.translatesAutoresizingMaskIntoConstraints = false
        textView1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let textField1 = UITextField()
        textField1.borderStyle = .roundedRect
        textField1.placeholder = "TextField 1"
        textField1.font = font
        textField1.adjustsFontForContentSizeCategory = true
        
        let stackView = UIStackView(arrangedSubviews: [label1, label2, myButton, button1, touchLabel, textField1, textView1])
        stackView.axis = .vertical
        stackView.frame = view.bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //view.addSubview(stackView)
        view.insertSubview(stackView, at: 0)
        
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        myButton.sizeToFit()
    }
}

