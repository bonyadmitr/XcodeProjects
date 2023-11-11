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
        
    }


}


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
