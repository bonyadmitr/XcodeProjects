import UIKit

final class AppConfigurator {
    
    weak var window: UIWindow?
    
    private func setupApp() {
        #if DEBUG
        #endif
    }
    
    /// SceneDelegate Without Storyboard (short and simple) https://samwize.com/2019/08/05/setup-scenedelegate-without-storyboard/
    /// UIScene programmatic https://medium.com/@ZkHaider/apples-new-uiscene-api-a-programmatic-approach-52d05e382cf2
    @available(iOS 13.0, *)
    func setup(scene: UIScene) -> UIWindow? {
        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure()
            return nil
        }
        
        let window = UIWindow(windowScene: windowScene)
        setupApp()
        setupWindow(window)
        return window
    }
    
    func setupWindowForAppDelegate() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return nil
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            setupApp()
            setupWindow(window)
            return window
        }
    }
    
    private func setupWindow(_ window: UIWindow) {
        let countiesController = CountiesController()
        let navVC = UINavigationController(rootViewController: countiesController)
        
        let vc = ViewController()
        navVC.pushViewController(vc, animated: false)
        
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
extension AppConfigurator {
    static let shared = AppConfigurator()
}
