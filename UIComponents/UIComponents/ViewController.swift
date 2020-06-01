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
        
        let button1 = UIButton()
        button1.setTitle("button1", for: .normal)
        
        let button2 = UIButton()
        button2.setTitle("button2", for: .normal)
        
        let button3 = UIButton(type: .system)
        button3.setTitle("button3", for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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
    static let main = UIColor.magenta
    static let mainHighlighted = UIColor.magenta.darker()
    
    static let text = UIColor.label
    static let textHighlighted = UIColor.label.darker()
    
    static let white = UIColor.white
    static let whiteHighlighted = UIColor.white.darker()
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

/// inspired https://stackoverflow.com/a/60423075/5893286
class HighlightButton: MultiLineButton {

    var normalBackgroundColor: UIColor = .clear {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }

    var highlightedBackgroundColor: UIColor = .clear

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
        }
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let font = titleLabel?.font
        titleLabel?.font = nil
        titleLabel?.font = font
    }
    
}

// TODO: refactor
func getLinkFontAttrString(text: String) -> NSMutableAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [
        //.foregroundColor: UIColor.azure,
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        //.font: UIFont.systemFont(ofSize: 16, weight: .bold).dynamic()
    ]
    return NSMutableAttributedString(string: text, attributes: attributes)
}
