//
//  AppDelegate.swift
//  NavigationPopup
//
//  Created by Yaroslav Bondar on 15/01/2019.
//  Copyright © 2019 Yaroslav Bondar. All rights reserved.
//

import UIKit

final class NavigationPopup: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let innerView = UIButton()
        innerView.backgroundColor = .red
        
        let constant: CGFloat = 50
        innerView.frame = CGRect(x: constant, y: constant,
                                 width: view.bounds.width - constant * 2,
                                 height: view.bounds.height - constant * 2)
        
        innerView.addTarget(self, action: #selector(push), for: .touchUpInside)
        innerView.setTitle("Push", for: .normal)
        
        view.addSubview(innerView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func push() {
        let vc = UIViewController()
        vc.view.backgroundColor = .magenta
        navigationController?.pushViewController(vc, animated: true)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navBarProxy = UINavigationBar.appearance()
        let backgroundColor = UIColor.yellow
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = backgroundColor
            navBarProxy.standardAppearance = navBarAppearance
            navBarProxy.scrollEdgeAppearance = navBarAppearance
        } else {
            navBarProxy.barTintColor = backgroundColor
        }
        
        // Override point for customization after application launch.
        window = UIWindow()
        window?.backgroundColor = UIColor.cyan
        
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = UIColor.green
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let vc = NavigationPopup()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.navigationBar.isTranslucent = false
            navVC.modalPresentationStyle = .overFullScreen
            navVC.modalTransitionStyle = .crossDissolve
            
            rootVC.present(navVC, animated: true, completion: nil)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

