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
//        window.rootViewController = StartController()
        window.makeKeyAndVisible()
        appDelegate.window = window
        self.window = window
    }
    
    func startWithMainApp() {
        window.rootViewController = MainController()
    }
    
    func startWithSplash() {
        window.rootViewController = StartController()
    }
}

import UIKit

final class StartController: LabelController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Start"
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
        
        let isLoggedIn = true
        if isLoggedIn {
            router.startWithMainApp()
        } else {
            router.startWithSplash()
        }

        return true
    }
}
