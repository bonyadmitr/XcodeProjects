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
    
}
