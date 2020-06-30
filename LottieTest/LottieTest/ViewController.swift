import UIKit
import Lottie

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = UILabel()
        animationView.text = "Main screen"
        animationView.frame = view.bounds
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(animationView)
        
    }


}

final class SplashController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("- viewDidLoad")
        
        /// doc https://airbnb.io/lottie/#/ios
        /// player https://loupthibault.github.io/bodymovin-player/
        /// rus article https://habr.com/ru/post/451638/
        let animationView = AnimationView(name: "fishes_lottie")
        
        //let animationView = AnimationView()
        //let animation = Animation.named("fishes_lottie", animationCache: LRUAnimationCache.sharedCache)
        //animationView.animation = animation
        
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.frame = view.bounds
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(animationView)
        
        //starAnimationView.play()
        animationView.play { finished in
            /// not called for 'loopMode = .loop' and 'backgroundBehavior = .pauseAndRestore'
            print("- finished: \(finished)")
        }
        
        openMain()
    }
    
    /// working in background
    private func openMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let window = UIApplication.shared.keyWindow else {
                assertionFailure()
                return
            }
            window.rootViewController = ViewController()
            self.animateReload(for: window)
        }
    }
    
    private func animateReload(for window: UIWindow) {
        /// you can set any animations https://github.com/malcommac/UIWindowTransitions
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
        }, completion: nil)
    }
    
}
