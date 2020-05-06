//
//  NotificationManager.swift
//  Notifications10
//
//  Created by Bondar Yaroslav on 30/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    let center = UNUserNotificationCenter.current()
    var badge: NSNumber = NSNumber(value: 1)
    
    override init() {
        super.init()
        registerActions()
        center.delegate = self
    }
    
    func register() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
//            if granted {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
            
            if let error = error {
                print("requestAuthorization error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendAlert() {
        badge = NSNumber(value: badge.intValue + 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "someAlert", content: getContent(), trigger: trigger)
        
        center.removeAllPendingNotificationRequests()
        center.add(request) { error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func registerActions() {
        let fruitAction = UNNotificationAction(identifier: "addFruit", title: "Add a piece of fruit", options: [])
        let vegiAction = UNNotificationAction(identifier: "addVegetable", title: "Add a piece of vegetable", options: [])
        
        let category = UNNotificationCategory(identifier: "foodCategory", actions: [fruitAction, vegiAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func getContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "title 1"
        content.subtitle = "subtitle 2"
        content.body = "body 3"
        content.sound = .default
        content.badge = badge
        content.userInfo = ["someKey": 123]
        content.launchImageName = "keyboard_icon"
        content.categoryIdentifier = "foodCategory" //!!!!!!!!!!
        return content
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.actionIdentifier)
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(notification.request.content.userInfo)
        print("presenting")
        
        /// to show in active app
        completionHandler([.alert, .sound, .badge])
        
        /// to hide in active app
//        completionHandler([])
    }
}

