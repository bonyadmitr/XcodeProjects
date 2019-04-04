import UIKit

let router = Router()
let factory = Factory()

//extension UIViewController {
//    var router: Router {
//        return globalRouter
//    }
//}

var isLoggedIn = false

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        router.setup(appDelegate: self)
        
        
        if isLoggedIn {
            router.startWithMainApp()
        } else {
            router.startWithLogin()
        }
        /// deeplink
        /// router://open?vc=1&action=push
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        
        guard
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            urlComponents.host == "open",
            let queryItems = urlComponents.queryItems,
            let vcName = queryItems.first(where: { $0.name == "vc" })?.value
        else {
            return false
        }
        
        if isLoggedIn {
            if vcName == "1",
                let vc = router.show1(),
                let navVC = vc.selectedViewController as? UINavigationController,
                let actionsVC = navVC.topViewController as? ActionsController,
                let action = queryItems.first(where: { $0.name == "action" })?.value,
                action == "push"
            {
                    actionsVC.push()
            }
        } else {
            
        }
        
        return false
    }
}
