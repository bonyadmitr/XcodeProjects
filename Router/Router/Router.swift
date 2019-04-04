import UIKit

final class Router {
    
    private var window: UIWindow!
    
    func setup(appDelegate: AppDelegate) {
        let window = UIWindow()
        window.backgroundColor = UIColor.cyan
        window.makeKeyAndVisible()
        appDelegate.window = window
        self.window = window
    }
    
    func startWithMainApp() {
        window.rootViewController = factory.main()
    }
    
    func startWithLogin() {
        window.rootViewController = factory.login()
    }
    
    func openMain() {
        startWithMainApp()
    }
    
    func logout() {
        // logout from all services
        startWithLogin()
    }
}
