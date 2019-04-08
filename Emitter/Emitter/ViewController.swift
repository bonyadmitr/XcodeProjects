import UIKit

final class ConfettiViewController: UIViewController {
    
    private lazy var confettiView = SAConfettiView(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(confettiView, at: 0)
        confettiView.startConfetti()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        confettiView.frame = view.bounds
    }
}

final class SnowViewController: UIViewController {

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
