//
//  AppDelegate.swift
//  Router
//
//  Created by Yaroslav Bondar on 04/04/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

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

final class Factory {
    func main() -> UIViewController {
        return TabBarController()
    }
    
    func login() -> UIViewController {
        return LoginController()
    }
    
    func vc1() -> UIViewController {
        let vc = LabelController()
        vc.label.text = "111"
        vc.title = "111"
        vc.view.backgroundColor = UIColor.magenta
        return vc
    }
    
    func vc2() -> UIViewController {
        let vc = LabelController()
        vc.label.text = "222"
        vc.title = "222"
        vc.view.backgroundColor = UIColor.cyan
        return vc
    }
}

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [factory.vc1(), factory.vc2()]
    }
}

import UIKit

final class LoginController: LabelController {
    
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        label.text = "Login"
        
//        loginButton.setTitleColor(UIColor.blue, for: .normal)
//        loginButton.backgroundColor = .red
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(loginButton)
//        loginButton.frame = CGRect(x: 20, y: 20, width: view.bounds.width - 20 * 2, height: 44)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton.sizeToFit()
        loginButton.frame = CGRect(x: 20, y: 20, width: view.bounds.width - 20 * 2, height: 44)
        
    }
    
    @objc private func login() {
        router.openMain()
    }
}


import UIKit

final class MainController: LabelController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Main"
    }
    
}

import UIKit

class LabelController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.sizeToFit()
        label.center = view.center
    }
}

private let router = Router()
private let factory = Factory()

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
