//
//  ViewController.swift
//  GradientsReview
//
//  Created by Yaroslav Bondar on 08.11.2023.
//

import UIKit


// TODO: gradient with fixed started Locations


/*
     @IBInspectable var firstColor: UIColor = UIColor.magenta {
        didSet { updateColors() }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.cyan {
        didSet { updateColors() }
    }
 
 @IBInspectable var verticalMode: Bool = true
 */

class ViewController: UIViewController {

    @IBOutlet private weak var gradientView: GradientThemeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(UIColor(light: .red, dark: .blue).resolvedColor(for: .light) == .red)
        assert(UIColor(light: .red, dark: .blue).resolvedColor(for: .unspecified) == .red)
        assert(UIColor(light: .red, dark: .blue).resolvedColor(for: .dark) == .blue)
        
        
        
//        gradientView.setDirection(.leftToRight)
        gradientView.setColors([.red, .orange])
        //gradientView.setColors([.label, .systemBackground])
        
//        gradientView.gradientLayer.locations = [0, 0.3, 0.7, 1]
        //gradientView.gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
//        gradientView.setColors([.red, .orange, .green, .blue])
        
//        gradientView.setColors([.systemBackground, UIColor(light: .red, dark: .blue)])
        
        
    
//        gradientView.setLocationsAndColors([0.0: .red,
//                                           0.3: .orange,
//                                           0.7: .green,
//                                           1.0: .blue])
        
        
//        gradientView.setLocationsAndColors([0.0: .systemBackground,
//                                           0.3: .secondarySystemBackground,
//                                           0.7: .tertiarySystemBackground,
//                                           1.0: .systemGroupedBackground])
        
//        gradientView.setLocationsAndColors([0.5: .systemBackground,
//                                            0.9: .label])
        
        
        
        
        let vw = UIView(frame: CGRect(x: 100, y: 600, width: 128, height: 128))
        vw.backgroundColor = .white
        
        vw.layer.shadowOffset = .zero
        vw.layer.shadowColor = UIColor.yellow.cgColor
        vw.layer.shadowRadius = 20
        vw.layer.shadowOpacity = 1
        vw.layer.shadowPath = UIBezierPath(rect: vw.bounds).cgPath
        view.addSubview(vw)
    }


}


final class GradientShadowView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let shadowLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
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
