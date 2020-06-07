//
//  ViewController.swift
//  UIComponents
//
//  Created by Bondar Yaroslav on 5/31/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background
        /// to test shadows
        //view.backgroundColor = .darkGray
        
        let button1 = ButtonMain()
        
//        button1.setTitle("Push", for: .normal)
//        button1.setImage(UIImage(systemName: "folder.fill"), for: .normal)
        
        //let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(textStyle: .body))
        
        /// working in UIButton(type: .system)
        let image = UIImage(systemName: "square.and.arrow.up")
        button1.image = image
        //button1.currentPreferredSymbolConfiguration
        
//        let q = UIImage.SymbolConfiguration(textStyle: .body)
//        button1.setPreferredSymbolConfiguration(q, forImageIn: .normal)
        
//        UIImage.SymbolConfiguration.unspecified
        button1.setTitle("Поделиться статьей", for: .normal)
        
        button1.addTarget(self, action: #selector(push), for: .touchUpInside)
        //button1.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let button2 = ButtonMain()
        button2.setTitle("Present wwww www www wwwww", for: .normal)
        button2.addTarget(self, action: #selector(presentVC), for: .touchUpInside)
        
        let button3 = UIButton(type: .system)
        button3.setTitle("System Push", for: .normal)
        button3.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button3.tintColor = Colors.white
        button3.backgroundColor = Colors.main
        button3.addTarget(self, action: #selector(push), for: .touchUpInside)
        button3.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button3.layer.cornerRadius = 8
        //button3.isEnabled = false
        
        let button4 = LinkButton()
        button4.setLinkText("Some link wqw qwq wwww www www wwwww")
        button4.addTarget(self, action: #selector(push), for: .touchUpInside)
        
        let button5 = GhostButton()
        button5.setTitle("Ghost button wwwww", for: .normal)
        button5.addTarget(self, action: #selector(push), for: .touchUpInside)
        
        let button6 = GhostButton2()
        //button6.tintColor = Colors.main
        button6.setTitle("Ghost button 2 wwwww", for: .normal)
        button6.image = image
        button6.imageEdgeInsets.right = 8
        button6.addTarget(self, action: #selector(push), for: .touchUpInside)
        
        let placeholderTextView = PlaceholderTextView()
        placeholderTextView.placeholder = "Some placeholder wwww www www wwwww www"
        //placeholderTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        placeholderTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [placeholderTextView, button1, button2, button3, button4, button5, button6])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        //stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            //            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc private func push() {
        let vc = ViewController()
        vc.view.backgroundColor = .lightGray
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func presentVC() {
        let vc = ViewController()
        vc.view.backgroundColor = .darkGray
        present(vc, animated: true)
    }
}

/**
 Core Animation engineer: use cornerRadius https://twitter.com/TimOliverAU/status/1135999854176395264
 How to set corner radius in iOS  https://onmyway133.github.io/blog/How-to-set-corner-radius-in-iOS/
 shadow http://www.lukeparham.com/blog/2018/3/6/friends-dont-let-friends-render-offscreen
 */

class RoundedProgressView: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.midY
        layer.masksToBounds = true
    }
}

extension UIView {
    
    @discardableResult func rounded() -> CAShapeLayer {
        return round(corners: .allCorners, radius: bounds.midY)
    }
    
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }

    /// source https://stackoverflow.com/a/35621736/5893286
    @discardableResult func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }

    func addBorder(mask: CAShapeLayer?, borderColor: UIColor, borderWidth: CGFloat) {
        //layer.sublayers
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask?.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth// * UIScreen.main.scale
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }

    /// source https://gist.github.com/shaildyp/6cd1de39498ff7b3c22fa758f005f7cd
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    // TODO: Different cornerRadius for each corner https://stackoverflow.com/a/53128198/5893286
    // TODO: super-ellipse corners https://gist.github.com/Joony/04cf46cd884eb497d6590b632740b08d
}

extension CACornerMask {
    static var all: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
}

protocol Circled {}
extension Circled where Self: UIView {
    func initSetupCircled() {
        layer.masksToBounds = true
    }

    func layoutSubviewsSetupCircled() {
        // TODO: test performance. iOS 11+ and 11-
        //layer.maskedCorners = .all
        
        layer.cornerRadius = bounds.height * 0.5
        //layer.cornerRadius = bounds.midY
    }
}

protocol Rounded {}
extension Rounded where Self: UIView {
    func initSetupRounded() {
        // TODO: test performance. iOS 11+ and 11-
        //layer.maskedCorners = .all
        layer.cornerRadius = 8
    }
}

protocol Shadowed {}
extension Shadowed where Self: UIView {
    func initSetupShadow() {
        
//        addShadow(offset: .zero, color: .black, radius: 5, opacity: 0.5)
        
        layer.masksToBounds = false
        layer.shadowOffset = .zero//CGSize(width: 5.0, height: 5.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
//
//        let backgroundCGColor = backgroundColor?.cgColor
//        backgroundColor = nil
//        layer.backgroundColor =  backgroundCGColor
    }

    func layoutSubviewsSetupShadow() {
        //CGPath(rect: bounds, transform: nil)
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}

extension UIView {
    
    /// https://stackoverflow.com/a/43295741/5893286
    /// button3.setBackgroundColor(.magenta, for: .normal)
    /// only button3.backgroundColor = .magenta
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

// TODO: CollageView
//final class CollageView: UIView {
//
//    @IBOutlet private weak var imagesStackView: UIStackView! {
//        willSet {
//            newValue.spacing = 10
//            newValue.alignment = .bottom
//            newValue.axis = .horizontal
//            newValue.distribution = .fill
//        }
//    }
//
//    private lazy var imageHeight: CGFloat = imagesStackView.bounds.height
//
//    private func createImageView(with image: UIImage) -> UIImageView {
//        let width = image.size.width
//        let height = image.size.height
//        let scaleFactor = width / height
//        let imageViewWidth = imageHeight * scaleFactor
//
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
//        imageHeight -= 10
//
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowRadius = 2
//        imageView.layer.shadowOpacity = 0.3
//        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
//
//        return imageView
//    }
//
//    func setup(images: [UIImage]){
//        images
//            .compactMap { self.createImageView(with: $0) }
//            .forEach { self.imagesStackView.addArrangedSubview($0) }
//    }
//}

// TODO: fix highlighted on fast touch
/// https://stackoverflow.com/a/40062642/5893286
/// https://stackoverflow.com/q/4627154/5893286
//public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        isHighlighted = true
//    setBackgroundColor(UIColor.magenta.darker(by: 30), for: .normal)
//    super.touchesBegan(touches, with: event)
//    //OperationQueue.main.addOperation { self.isHighlighted = true }
//}
//
//public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    super.touchesEnded(touches, with: event)
//    setBackgroundColor(UIColor.magenta, for: .normal)
//
//}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = UIImage(color: color)
        setBackgroundImage(image, for: state)
    }
}

extension UIImage {
    convenience init?(color: UIColor) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIColor {
        
    open func lighter(by percentage: CGFloat = 30) -> UIColor {
        return adjust(by: abs(percentage) )
    }
    
    open func darker(by percentage: CGFloat = 30) -> UIColor {
        return adjust(by: -1 * abs(percentage) )
    }
    
    open func adjust(by percentage: CGFloat = 30) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return self
        }
        return UIColor(red: min(r + percentage / 100, 1.0),
                       green: min(g + percentage / 100, 1.0),
                       blue: min(b + percentage / 100, 1.0),
                       alpha: a)
    }
    
}


//final class ButtonTest: UIButton {
//
//    private var observer: NSKeyValueObservation?
//
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
//        /// https://stackoverflow.com/a/47684777/5893286
//        observer = layer.observe(\.bounds) { object, _ in
//            print("- observer bounds", object.bounds)
//        }
//        /// not called for button
//        //observer = layer.observe(\.frame) { object, _ in
//        //    print("- observer frame", object.frame)
//        //}
//    }
//
//    override var frame: CGRect {
//        didSet {
//            /// .zero for button
//            print("- frame", frame)
//        }
//    }
//
//    override var bounds: CGRect {
//        didSet {
//            print("- bounds", bounds)
//        }
//    }
//
//    /// called several times
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print("- layoutSubviews", frame)
//    }
//
//    deinit {
//        observer?.invalidate()
//    }
//}
//
//final class ViewTest: UIView {
//
//    private var observer: NSKeyValueObservation?
//
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
//        backgroundColor = .red
//
//        /// https://stackoverflow.com/a/47684777/5893286
//        observer = layer.observe(\.bounds) { object, _ in
//            print("- observer bounds", object.bounds)
//        }
//        /// not called for button
//        //observer = layer.observe(\.frame) { object, _ in
//        //    print("- observer frame", object.frame)
//        //}
//    }
//
//    override var frame: CGRect {
//        didSet {
//            /// .zero for button
//            /// called twice for UIVIew
//            print("- frame", frame)
//        }
//    }
//
//    override var bounds: CGRect {
//        didSet {
//            print("- bounds", bounds)
//        }
//    }
//
//    /// called several times
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print("- layoutSubviews", frame)
//    }
//
//    deinit {
//        observer?.invalidate()
//    }
//}

enum Colors {
    ///  apple colors https://gist.github.com/DavidRysanek/fcca558c27e4e7b7d89d88b1fabeb4f1
    static let main = UIColor.systemBlue
    static let mainHighlighted = UIColor.systemBlue.darker()
    
    static let text = UIColor.label
    static let textHighlighted = UIColor.label.darker()
    
    static let white = UIColor.white
    static let whiteHighlighted = UIColor.white.darker()
    
    static let background = UIColor.systemBackground
}

enum Fonts {
    //static let button = UIFont.preferredFont(forTextStyle: .body)
    //static let button = UIFont.systemFont(ofSize: 17).dynamic()
    static let button = UIFont(name: "HelveticaNeue", size: 17)!
    
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
    
    func setDynamicFont(_ font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
    
}

extension UIButton {
    
    func setDynamicFont(_ font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        titleLabel?.setDynamicFont(font, for: textStyle)
    }
    
}

extension UITextField {
    
    func setDynamicFont(_ font: UIFont, for textStyle: UIFont.TextStyle = .body) {
        self.font = font.dynamic(for: textStyle)
        adjustsFontForContentSizeCategory = true
    }
    
}

/// inspired https://stackoverflow.com/a/60423075/5893286
class HighlightButton: MultiLineButton {

    var normalBackgroundColor: UIColor = .clear {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }

    var highlightedBackgroundColor: UIColor = .clear
    
    var normalTintColor = UIColor.clear {
        didSet {
            tintColor = normalTintColor
            setTitleColor(normalTintColor, for: .normal)
        }
    }
    var highlightedTintColor = UIColor.clear {
        didSet {
            setTitleColor(highlightedTintColor, for: .highlighted)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
            
            /// To get rid of the tint background https://sasablagojevic.com/how-to-get-rid-of-blue-uibutton-background-on-different-states
            tintColor = isHighlighted ? highlightedTintColor : normalTintColor
        }
    }
    
    var image: UIImage? {
        get {
            return currentImage
        }
        set {
            setImage(newValue, for: .normal)
            
            /// or 1
            //adjustsImageWhenHighlighted = false
            
            /// or 2
            //setImage(newValue, for: .highlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        adjustsImageWhenHighlighted = false
        //adjustsImageWhenDisabled = false
        
        // TODO: check
        //tintAdjustmentMode = .automatic
    }
    
}

final class ButtonMain: HighlightButton, Shadowed, Rounded {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() -> Void {
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        normalBackgroundColor = Colors.main
        highlightedBackgroundColor = Colors.mainHighlighted
        
        normalTintColor = Colors.white
        highlightedTintColor = Colors.whiteHighlighted
        
        imageEdgeInsets.right = 8
        
        setDynamicFont(Fonts.button)
        
        initSetupRounded()
        initSetupShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviewsSetupShadow()
    }
    
}

/// button frame autolayout https://stackoverflow.com/a/35321242/5893286
/// test by:
//backgroundColor = .red
//titleLabel?.backgroundColor = .green
class MultiLineButton: DynamicFontButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
    }
    
    override var intrinsicContentSize: CGSize {
        return titleLabel?.intrinsicContentSize ?? .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.bounds.width ?? 0
        super.layoutSubviews()
    }
    
}

class DynamicFontButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupDynamicImage()
    }
    
    private func setupDynamicImage() {
        /// UIDynamicProviderImage https://gist.github.com/SpectralDragon/4ddd2a01d8027a2ff831af8859861764
        
        ///default  custom button
        //currentPreferredSymbolConfiguration == UIImage.SymbolConfiguration(scale: .medium)
        
        /// default system button
        //currentPreferredSymbolConfiguration ==  UIImage.SymbolConfiguration(textStyle: .body, scale: .large)
        
        let symbolConfig = UIImage.SymbolConfiguration(textStyle: .body, scale: .large)
        setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory else {
            return
        }
        
        // TODO: is it needed?
        /// update fonts
        let font = titleLabel?.font
        titleLabel?.font = nil
        titleLabel?.font = font
        
        /// update images
        guard let currentPreferredSymbolConfiguration = currentPreferredSymbolConfiguration else {
            assertionFailure("use setPreferredSymbolConfiguration")
            return
        }
        
        [UIControl.State.normal, .highlighted, .selected, .disabled].forEach { state in
            let img = image(for: state)?.withConfiguration(currentPreferredSymbolConfiguration)
            setImage(img, for: state)
        }
        
    }
    
}

final class LinkButton: MultiLineButton {
    
    var normalLinkColor: UIColor = .blue {
        didSet {
            titleLabel?.textColor = normalLinkColor
        }
    }
    
    var highlightedLinkColor: UIColor = UIColor.blue.darker()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel?.textColor = isHighlighted ? highlightedLinkColor : normalLinkColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() -> Void {
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        setDynamicFont(Fonts.button)
        
        normalLinkColor = Colors.main
        highlightedLinkColor = Colors.mainHighlighted
    }
    
    func setLinkText(_ text: String) {
        setAttributedTitle(getLinkFontAttrString(text: text), for: .normal)
    }
    
}

// TODO: refactor
func getLinkFontAttrString(text: String) -> NSMutableAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [
        /// apple says that we need to set foregroundColor for dynamic change
        /// but it working without it in UIButton with setAttributedTitle
        //.foregroundColor: UIColor.azure,
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        //.font: UIFont.systemFont(ofSize: 16, weight: .bold).dynamic()
    ]
    return NSMutableAttributedString(string: text, attributes: attributes)
}

class GhostButton: MultiLineButton, Rounded {
    
    var normalTintColor: UIColor = .white {
        didSet {
            layer.borderColor = normalTintColor.cgColor
            setTitleColor(normalTintColor, for: .normal)
        }
    }
    
    var highlightedTintColor: UIColor = UIColor.white.darker() {
        didSet {
            setTitleColor(highlightedTintColor, for: .highlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var isHighlighted: Bool {
        didSet {
            layer.borderColor = isHighlighted ? highlightedTintColor.cgColor : normalTintColor.cgColor
        }
    }
    
    private func setup() -> Void {
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        normalTintColor = Colors.main
        highlightedTintColor = Colors.mainHighlighted
        
        setDynamicFont(Fonts.button)
        
        layer.borderWidth = 2
        
        initSetupRounded()
    }
    
}

/// set normalBackgroundColor != UIColor.clear
final class GhostButton2: HighlightButton, Rounded {
    
    override var normalTintColor: UIColor {
        didSet {
            highlightedBackgroundColor = normalTintColor
            layer.borderColor = normalTintColor.cgColor
        }
    }
    
    override var normalBackgroundColor: UIColor {
        didSet {
            //let fixedColor = (normalBackgroundColor == UIColor.clear) ? Colors.background : normalBackgroundColor
            setTitleColor(normalBackgroundColor, for: .highlighted)
            highlightedTintColor = normalBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //override func didMoveToSuperview() {
    //    super.didMoveToSuperview()
    //
    //    /// not working with UIStackView. it's backgroundColor == nil
    //    let superviewBackgroundColor = superview?.backgroundColor ?? .clear
    //    normalBackgroundColor = superviewBackgroundColor
    //}
    
    private func setup() -> Void {
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        normalTintColor = Colors.text
        normalBackgroundColor = Colors.background
        
        setDynamicFont(Fonts.button)
        
        layer.borderWidth = 2
        
        initSetupRounded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        /// not working COLOR.resolvedColor(with: traitCollection).cgColor https://stackoverflow.com/a/57177411/5893286
        /// cgColor update https://stackoverflow.com/a/58312205/5893286
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = normalTintColor.cgColor
        }

    }
    
}

// TODO: optimize set titleLabel?.backgroundColor and titleLabel?.isOpaque = true
// TODO: optimize shadows for dark theme
// TODO: disabled state for buttons
// TODO: textField password show/hide + custom font fix
// TODO: textField datepicker
// TODO: textField custom picker
// TODO: textField tap or label + placeholder
// TODO: toolbar
// TODO: textField + image
// TODO: textField limit
// TODO: textField insets InsetsTextField https://stackoverflow.com/a/3969703/5893286
// TODO: textField mask for phones
// TODO: textField + formatter date/carrency
// TODO: textField custom design, title label, underline highlight
// TODO: textField error label/design
// TODO: textField error animation
// TODO: textView max hight
// TODO: autoscroling label
// TODO: button image+text

// TODO: disable Long press gesture recogniser in textView
//https://stackoverflow.com/a/47941549/5893286
//https://stackoverflow.com/a/53171516/5893286
//https://stackoverflow.com/a/44878203/5893286
