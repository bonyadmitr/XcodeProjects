//
//  AppDelegate.swift
//  MVC
//
//  Created by Bondar Yaroslav on 16/03/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)
    
    override init() {
        super.init()
        
        let loginModelController = LoginModelController()
        
        //let loginView = LoginView.initFromNib()
        //let loginVC = LoginViewController(view: loginView, model: loginModelController)
        
        let loginVC = LoginViewController2(model: loginModelController)
        
        window.rootViewController = loginVC
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        window.makeKeyAndVisible()
        return true
    }
}

