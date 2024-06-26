//
//  ViewController.swift
//  DynamicFont
//
//  Created by Bondar Yaroslav on 5/4/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// UIFontPickerController https://medium.com/swlh/how-to-implement-custom-font-with-uifontpickercontroller-in-ios-13-5a06958c73d3

/// iOS 10 Attributed Text https://medium.com/livefront/practical-dynamic-type-part-3-attributed-text-65c39d8586c4
/// Custom Font With Dynamic Type https://useyourloaf.com/blog/using-a-custom-font-with-dynamic-type/

/// UIFontMetrics.default.scaledFont for ios < 11 https://stackoverflow.com/q/20510094/5893286
/// apple video https://developer.apple.com/videos/play/wwdc2016/803/
/// apple typography https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography
//let customDynamicType: [UIContentSizeCategory: (pointSize: CGFloat, styleName: String,
//    leading: CGFloat,  tracking: CGFloat)] = [
//        .extraSmall:                        (10.0, "Heavy",  3.0, 0.6),
//        .small:                             (12.0, "Heavy",  2.0, 0.4),
//        .medium:                            (14.0, "Roman",  1.0, 0.2),
//        .large:                             (14.0, "Roman",  0.0, 0.0),
//        .unspecified:                       (16.0, "Roman",  0.0, 0.0),
//        .extraLarge:                        (17.0, "Roman",  0.0, 0.0),
//        .extraExtraLarge:                   (18.0, "Light",  -1.0, 0.0),
//        .extraExtraExtraLarge:              (19.0, "Light",  -2.0, -0.1),
//        .accessibilityMedium:               (20.0, "Light",  -3.0, -0.2),
//        .accessibilityLarge:                (21.0, "Light",  -4.0, -0.2),
//        .accessibilityExtraLarge:           (22.0, "Light",  -4.0, -0.2),
//        .accessibilityExtraExtraLarge:      (23.0, "Light",  -4.0, -0.2),
//        .accessibilityExtraExtraExtraLarge: (24.0, "Light",  -4.0, -0.2)
//]
//let fontType = customDynamicType[UIApplication.shared.preferredContentSizeCategory]

/// custom sizes https://github.com/chuonglaquoc/GV247New_Tam/blob/master/GV24/Extentions/ChangeFontSize.swift

/// automatization change font size in tests https://stackoverflow.com/a/55341947/5893286

/// source https://stackoverflow.com/a/35357416/5893286
//let pointSize  = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
//let customFont = UIFont(name: "Chalkboard SE", size: pointSize)

/// dynamic size UI elements
//let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
//let heightBeforeScaling: CGFloat = 44.0
//let height = headlineMetrics.scaledValue(for: heightBeforeScaling)

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
        
        /// UIFontDescriptor.SystemDesign example https://github.com/darjeelingsteve/system-design-example
        guard let fontDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .body)
            .addingAttributes([UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.black]])
            .withDesign(.rounded) /// write at the end
        else {
            assertionFailure()
            return
        }
        let font = UIFont(descriptor: fontDescriptor, size: fontDescriptor.pointSize)
        
        //let font = UIFont.systemFont(ofSize: 30)
        //let font = UIFont.preferredFont(forTextStyle: .body)
        
        //let font = UIFont.systemFont(ofSize: 30).dynamic()
        
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

//final class SegmentedControl: UISegmentedControl {
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        allSubviews(of: UILabel.self)
//            .forEach { $0.adjustsFontSizeToFitWidth() }
//    }
//}
//
//extension UILabel {
//    func adjustsFontSizeToFitWidth() {
//        minimumScaleFactor = 0.5
//        adjustsFontSizeToFitWidth = true
//    }
//}
