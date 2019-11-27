import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        /// SceneDelegate Without Storyboard (short and simple) https://samwize.com/2019/08/05/setup-scenedelegate-without-storyboard/
        /// UIScene programmatic https://medium.com/@ZkHaider/apples-new-uiscene-api-a-programmatic-approach-52d05e382cf2
        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure()
            return
        }
        // "Each key and value must be of the following types: NSArray, NSData, NSDate, NSDictionary, NSNull, NSNumber, NSSet, NSString, NSURL, or NSUUID"
//        scene.userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity ?? NSUserActivity(activityType: "restoration")
        
        /// or #1
        //let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        //window.windowScene = windowScene
        
        /// or #2
        let window = UIWindow(windowScene: windowScene)
        
        let vc = ProductsListController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isTranslucent = false
        navVC.navigationBar.prefersLargeTitles = false
        
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        
        // my strategy: each v.c. must have a restorationInfo property...
        // ...and must be handed this userInfo as it is created...
        // ...before its viewDidLoad has a chance to run
        // but then it must destroy it when it no longer needs it!
//        if let rvc = window?.rootViewController as? RootViewController {
//            rvc.restorationInfo = scene.userActivity?.userInfo
//        }
        
        //navVC.restoreUserActivityState(<#T##activity: NSUserActivity##NSUserActivity#>)
        
        // Do we have an activity to restore?
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            // Setup the detail view controller with it's restoration activity.
            if !configure(window: window, with: userActivity) {
                print("Failed to restore DetailViewController from \(userActivity)")
            }
        }
        
        self.window = window
    }
    
    private func configure(window: UIWindow?, with activity: NSUserActivity) -> Bool {
        let detailViewController = ProductDetailController()
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(detailViewController, animated: false)
            detailViewController.restoreUserActivityState(activity)
            return true
        }
        return false
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    func sceneWillResignActive(_ scene: UIScene) {
        if let navController = window!.rootViewController as? UINavigationController {
            if let detailViewController = navController.viewControllers.last as? ProductDetailController {
                // Fetch the user activity from our detail view controller so restore for later.
                scene.userActivity = detailViewController.detailUserActivity
            }
        }
    }

        
    // MARK: State Restoration
    
    // This is the NSUserActivity that will be used to restore state when the scene reconnects.
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}

