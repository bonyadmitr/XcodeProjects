//
//  ViewController.swift
//  GradientsReview
//
//  Created by Yaroslav Bondar on 08.11.2023.
//

import UIKit



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
