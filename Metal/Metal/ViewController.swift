import UIKit

class ViewController: UIViewController {

    private let snowEmitterLayer = SnowflakeEmitter.snowflakeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.magenta
        view.layer.addSublayer(snowEmitterLayer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        snowEmitterLayer.frame = view.bounds
        snowEmitterLayer.emitterSize.width = view.bounds.width
        snowEmitterLayer.emitterPosition.x = view.bounds.width / 3
    }
}
