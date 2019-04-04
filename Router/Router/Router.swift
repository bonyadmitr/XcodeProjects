import UIKit

final class Router {
    
    private var window: UIWindow!
    
    func setup(appDelegate: AppDelegate) {
        let window = UIWindow()
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
    
    @discardableResult
    func show1() -> TabBarController? {
        if let vc = window.rootViewController as? TabBarController {
            vc.show1()
            return vc
        }
        return nil
    }
    
    func show2() {
        if let vc = window.rootViewController as? TabBarController {
            vc.show2()
        }
    }
    
//    func show1Action() {
//        if let vc = window.rootViewController as? TabBarController {
//            vc.show1()
//        }
//    }
}
