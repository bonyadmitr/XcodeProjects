import UIKit
import Lottie

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("- viewDidLoad")
        
        /// doc https://airbnb.io/lottie/#/ios
        let animationView = AnimationView(name: "fishes_lottie")
        
        //let animationView = AnimationView()
        //let animation = Animation.named("fishes_lottie", animationCache: LRUAnimationCache.sharedCache)
        //animationView.animation = animation
        
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        
        //starAnimationView.play()
        animationView.play { finished in
            /// not called for 'loopMode = .loop' and 'backgroundBehavior = .pauseAndRestore'
            print("- finished: \(finished)")
        }
        
        animationView.frame = view.bounds
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(animationView)
        
    }


}

