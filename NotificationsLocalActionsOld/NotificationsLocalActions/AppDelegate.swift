//
//  AppDelegate.swift
//  NotificationsLocalActions
//
//  Created by zdaecqze zdaecq on 24.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//        -(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//            UIApplicationState state = [application applicationState];
//            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//            if (state == UIApplicationStateActive) {
//
//                UIAlertController * alert=   [UIAlertController
//                    alertControllerWithTitle:notification.alertTitle
//                    message:notification.alertBody
//                    preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction* ok = [UIAlertAction
//                    actionWithTitle:@"OK"
//                style:UIAlertActionStyleDefault
//                handler:^(UIAlertAction * action)
//                {
//                    [alert dismissViewControllerAnimated:YES completion:nil];
//
//                }];
//
//                [alert addAction:ok];
//
//                [self.navigationController presentViewController:alert animated:YES completion:nil];
//                
//            }

    
    
    
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //let viewController = self.window!.rootViewController as! ViewController
        //viewController.updateUI()
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
