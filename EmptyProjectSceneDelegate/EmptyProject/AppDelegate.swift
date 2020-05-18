//
//  AppDelegate.swift
//  EmptyProject
//
//  Created by Yaroslav Bondar on 29/11/2018.
//  Copyright © 2018 Yaroslav Bondar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = AppConfigurator.shared.setupWindowForAppDelegate()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        /// objc source https://gist.github.com/douglashill/1bd6ba60b50315455ed2b2381bc355dc
        let sceneConfig = UISceneConfiguration()
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
        
        //return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        self.window = AppConfigurator.shared.setup(scene: scene)
    }
}

final class AppConfigurator {
    
    static let shared = AppConfigurator()
    private init() {}
    
    weak var window: UIWindow?
    
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
    
    private func setupApp() {
    }
    
    private func setupWindow(_ window: UIWindow) {
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .cyan
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
