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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .magenta
        
        
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.green.cgColor,
                                UIColor.blue.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
//        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)

        
        
        
//        gradientLayer.masksToBounds = true
        
        
        
        shadowLayer.backgroundColor = UIColor.cyan.cgColor
        
        shadowLayer.shadowColor = UIColor.yellow.cgColor
        shadowLayer.shadowOpacity = 1 //0.08
        shadowLayer.shadowRadius = 20 // max for insetBy 40
        shadowLayer.shadowOffset = .zero
        
        
        /// inspired https://stackoverflow.com/a/45257449/5893286
        gradientLayer.mask = shadowLayer
        
        layer.addSublayer(gradientLayer)
        
        
        let cornerRadius: CGFloat =  16
        shadowLayer.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius

        
//        layer.addSublayer(shadowLayer)
    }
    
    static var topLeftToBottomRight: Self {
        .init(startPoint: CGPoint(x: 0, y: 0),
              endPoint: CGPoint(x: 1, y: 1))
        
//        let rect = CGRect.init(
//            x: bounds.minX - 40,
//            y: bounds.minY - 40,
//            width: bounds.width + 80,
//            height: bounds.height + 80)
        
        gradientLayer.frame = bounds.insetBy(dx: -40, dy: -40)
        
        /// when some of the layer is a mask then you should calculate the frame of the mask like if it is just a sublayer of the superlayer https://stackoverflow.com/a/30880145/5893286
        var f = gradientLayer.frame
        f.origin.x += 40
        f.origin.y += 40
        
        shadowLayer.frame = f.insetBy(dx: 40, dy: 40)
        
//        shadowLayer.frame = bounds//.insetBy(dx: 20, dy: 20)
//        shadowLayer.shadowPath = CGPath(rect: shadowLayer.frame, transform: nil)
        
        
//        shadowLayer.shadowPath = UIBezierPath(rect: rect.insetBy(dx: 20, dy: 20)).cgPath
    }
    
}
