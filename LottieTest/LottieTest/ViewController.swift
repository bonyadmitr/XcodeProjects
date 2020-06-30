import UIKit
import Lottie

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("- viewDidLoad")
        
        let animationView = AnimationView(name: "fishes_lottie")
        
        //let animationView = AnimationView()
        //let animation = Animation.named("fishes_lottie", animationCache: LRUAnimationCache.sharedCache)
        //animationView.animation = animation
        
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        
        //starAnimationView.play()
        animationView.play { finished in
            print("- finished: \(finished)")
        }
        
        animationView.frame = view.bounds
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(animationView)
        
    }


}

