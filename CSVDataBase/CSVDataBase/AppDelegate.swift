import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let lampsListController = LampsListController()
        let navVC = UINavigationController(rootViewController: lampsListController)
        navVC.navigationBar.isTranslucent = false
        
        let window = UIWindow()
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

final class LampsListController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
}

final class CSVParser {
    
    
    func start() {
        //http://lamptest.ru/led.csv
    }
}
