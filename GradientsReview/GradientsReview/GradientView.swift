//
//  GradientView.swift
//  GradientsReview
//
//  Created by Yaroslav Bondar on 12.11.2023.
//

import UIKit



//class GradientView: UIView {
//    override class var layerClass: AnyClass { CAGradientLayer.self }
//    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
//}
class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    /// topToBottom is default direction for CAGradientLayer
    func setColors(_ colors: [UIColor]) {
        assert(!colors.isEmpty)
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}

//extension GradientView {
//
//    struct Config {
//        let startPoint: CGPoint
//        let endPoint: CGPoint
//        let locations: [NSNumber]?
//        let colors: [CGColor]?
//        let type: CAGradientLayerType
//
//        init(startPoint: CGPoint,
//             endPoint: CGPoint,
//             locations: [NSNumber]? = nil,
//             colors: [CGColor]? = nil,
//             type: CAGradientLayerType = .axial)
//        {
//            self.startPoint = startPoint
//            self.endPoint = endPoint
//            self.locations = locations
//            self.colors = colors
//            self.type = type
//        }
//    }
//
//    func setupRaw(_ config: Config) {
//        gradientLayer.startPoint = config.startPoint
//        gradientLayer.endPoint = config.endPoint
//
//        if config.locations != nil {
//            gradientLayer.locations = config.locations
//        }
//
//        if config.colors != nil {
//            gradientLayer.colors = config.colors
//        }
//
//        gradientLayer.type = config.type
//    }
//}
//
///*
// TODO:
// diagonal
// RTL
// */
//extension GradientView.Config {
//
//    static var leftToRight: Self {
//        .init(startPoint: CGPoint(x: 0, y: 0),
//              endPoint: CGPoint(x: 1, y: 0))
//    }
//
//    static var rightToLeft: Self {
//        .init(startPoint: CGPoint(x: 1, y: 0),
//              endPoint: CGPoint(x: 0, y: 0))
//    }
//
//    /// default state for CAGradientLayer
//    static var topToBottom: Self {
//        .init(startPoint: CGPoint(x: 0, y: 0),
//              endPoint: CGPoint(x: 0, y: 1))
//    }
//
//    static var bottomToTop: Self {
//        .init(startPoint: CGPoint(x: 0, y: 1),
//              endPoint: CGPoint(x: 0, y: 0))
//    }
//
//}

extension GradientView {
    struct Direction {
        let startPoint: CGPoint
        let endPoint: CGPoint
    }
    
    func setDirection(_ direction: Direction) {
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
    }
}

extension GradientView.Direction {
    
    static var leftToRight: Self {
        .init(startPoint: CGPoint(x: 0, y: 0),
              endPoint: CGPoint(x: 1, y: 0))
    }
    
    static var rightToLeft: Self {
        .init(startPoint: CGPoint(x: 1, y: 0),
              endPoint: CGPoint(x: 0, y: 0))
    }
    
    /// default state for CAGradientLayer
    static var topToBottom: Self {
        .init(startPoint: CGPoint(x: 0, y: 0),
              endPoint: CGPoint(x: 0, y: 1))
    }
    
    static var bottomToTop: Self {
        .init(startPoint: CGPoint(x: 0, y: 1),
              endPoint: CGPoint(x: 0, y: 0))
    }
    
    static var topLeftToBottomRight: Self {
        .init(startPoint: CGPoint(x: 0, y: 0),
              endPoint: CGPoint(x: 1, y: 1))
    }
    
}

extension GradientView {
    
    func setLocationsAndColors(_ dict: [NSNumber: UIColor]) {
        assert(!dict.isEmpty)
        let sortedDict = dict.sorted(by: { $0.key.compare($1.key) == .orderedAscending })
        gradientLayer.locations = sortedDict.map { $0.key }
        setColors(sortedDict.map { $0.value })
    }
    
    //    func set(direction: GradientView.Direction, colors: [UIColor]) {
    //        setDirection(direction)
    //        setColors(colors)
    //    }
    
}

//extension GradientView.Config {
//    static var conic: Self {
//        .init(startPoint: CGPoint(x: 0.5, y: 0.5),
//              endPoint: CGPoint(x: 0.5, y: 0),
//              type: .conic)
//    }
//
//    static var custom: Self {
//        .init(startPoint: CGPoint(x: 0, y: 0),
//              endPoint: CGPoint(x: 1, y: 0),
//              locations: [0, 0.3, 0.7, 1],
//              colors: [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor])
//    }
//}


//extension GradientView {
//
//    func bottomToTop() {
//        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.locations = [0, 1]
//    }
//
//    func leftToRight() {
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//    }
//
//}


/// GradientDynamicColorsView
class GradientThemeView: GradientView {
    
    var colors = [UIColor]() {
        didSet {
            assert(colors.first { $0.resolvedColor(with: .init(userInterfaceStyle: .dark)) != $0.resolvedColor(with: .init(userInterfaceStyle: .light)) } != nil, "There is no dynamic color in \(colors). Use simple GradientView")
            updateColors()
        }
    }
    
    override func setColors(_ colors: [UIColor]) {
        self.colors = colors
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    private func updateColors() {
        assert(!colors.isEmpty, "`colors` is not used. Use simple GradientView")
        if !colors.isEmpty {
            super.setColors(colors)
        }
    }
}


extension UIColor {
    
    /// `.resolvedColor(with: .init(userInterfaceStyle: .dark))` -> `.resolvedColor(with: .dark)`
    func resolvedColor(for userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        resolvedColor(with: UITraitCollection(userInterfaceStyle: userInterfaceStyle))
    }
    
    convenience init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .dark ? dark : light }
    }
}


class GradientComplexView: UIView {
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    
    func setDynamicColors(_ colors: [UIColor]) {
        assert(!colors.isEmpty)
        assert(colors.first { $0.resolvedColor(with: .init(userInterfaceStyle: .dark)) != $0.resolvedColor(with: .init(userInterfaceStyle: .light)) } != nil, "There is no dynamic color in \(colors). Use `setStaticColors`")
        self.colors = colors
        setStaticColors(colors)
    }
    
}
