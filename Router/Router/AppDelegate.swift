import UIKit

let router = Router()
let factory = Factory()

//extension UIViewController {
//    var router: Router {
//        return globalRouter
//    }
//}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        router.setup(appDelegate: self)
        
        let isLoggedIn = false
        if isLoggedIn {
            router.startWithMainApp()
        } else {
            router.startWithLogin()
        }

        return true
    }
}
