//
//  UserNotificationManager.swift
//  UserLocalNotification
//
//  Created by Константин on 12.10.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

enum AttachmentType {
    case image
    case imageGif
    case audio
    case video
}

class UserNotificationManager: NSObject {
    
    static let shared = UserNotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            //handle error
        }
    }
    
    //MARK: - Add Default Notification
    func addNotificationWithTimeIntervalTrigger() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            //handle error
        }
    }
    
    func addNotificationWithCalendarTrigger() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        var components = DateComponents()
        components.weekday = 5
        components.hour = 13
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "calendar", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            //handle error
        }
    }
    
    func addNotificationWithLocationTrigger() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let center = CLLocationCoordinate2DMake(68.97917, 33.09251)
        let region = CLCircularRegion(center: center, radius: 100, identifier: "center")
        region.notifyOnEntry = false
        region.notifyOnExit = true
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(identifier: "calendar", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            //handle error
        }
    }
    
    //MARK: - Add Notification with Attachment
    func addNotificationWithAttachmentType(type: AttachmentType) {
        var contentSubtitle = ""
        var url: URL?
        
        switch type {
        case .image:
            contentSubtitle = "Subtitle Image"
            url = Bundle.main.url(forResource: "dance1", withExtension: "jpg")
            break
        case .imageGif:
            contentSubtitle = "Subtitle Image Gif"
            url = Bundle.main.url(forResource: "dance", withExtension: "gif")
            break
        case .audio:
            contentSubtitle = "Subtitle Audio"
//            url = Bundle.main.url(forResource: "skyrunning", withExtension: "wav")
            break
        case .video:
            contentSubtitle = "Subtitle Video"
//            url = Bundle.main.url(forResource: "video", withExtension: "mp4")
            break
        }
        
        let content = contentWith(contentSubtitle)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "attach", url: url!, options: nil)
            content.attachments = [attachment]
            self.addDelayNotificationWith(content)
        } catch {
            print("make attachment error!")
        }
    }
    
    //MARK: - Add Notification with Action
    func setCategories() {
        
        let action1 = UNNotificationAction(identifier: "action1", title: "Action 1", options: .authenticationRequired)
        let action2 = UNNotificationAction(identifier: "action2", title: "Start the App", options: .foreground)
        let category1 = UNNotificationCategory(identifier: "category1", actions: [action1, action2], intentIdentifiers: [], options: [])
        
        let action3 = UNNotificationAction(identifier: "action3", title: "Red Style", options: .destructive)
        let action4 = UNNotificationAction(identifier: "action4", title: "Unclock and Delete", options: [.authenticationRequired, .destructive])
        let category2 = UNNotificationCategory(identifier: "category2", actions: [action3, action4], intentIdentifiers: [], options: [])
        
        let action5 = UNTextInputNotificationAction(identifier: "action5", title: "", options: .foreground, textInputButtonTitle: "Send", textInputPlaceholder: "Enter something")
        let category3 = UNNotificationCategory(identifier: "category3", actions: [action5], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category1, category2, category3])
        
    }
    
    func addNotificationWithCategory1() {
        let content = contentWith("Category 1")
        content.categoryIdentifier = "category1"
        addDelayNotificationWith(content)
        
    }
    
    func addNotificationWithCategory2() {
        let content = contentWith("Category 2")
        content.categoryIdentifier = "category2"
        addDelayNotificationWith(content)
        
    }
    
    func addNotificationWithCategory3() {
        let content = contentWith("Category 3")
        content.categoryIdentifier = "category3"
        addDelayNotificationWith(content)
        
    }
    
    //MARK: - Add Notification with Custom UI
    func addLocalCustomUI() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "categoryCustonUI"
        
        let url = Bundle.main.url(forResource: "dance2", withExtension: "jpg")
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "attach", url: url!, options: nil)
            content.attachments = [attachment]
            self.addDelayNotificationWith(content)
        } catch {
            print("make attachment error!")
        }
    }
    
    func addCustomUIMediaPlay() {
        let playAction = UNNotificationAction(identifier: "play_action", title: "Play", options: .authenticationRequired)
        let printAction = UNNotificationAction(identifier: "print_action", title: "Print Text", options: .authenticationRequired)
        let commentAction = UNTextInputNotificationAction(identifier: "comment_action", title: "Comments", options: .foreground, textInputButtonTitle: "Send", textInputPlaceholder: "Enter something")
        
        let category = UNNotificationCategory(identifier: "categoryCustonUI", actions: [playAction, printAction, commentAction], intentIdentifiers: [], options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    //MARK: - Private
    func contentWith(_ subtitle: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = subtitle
        content.body = "Body"
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    func addDelayNotificationWith(_ content: UNNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Add notification: \((error != nil) ? "error" : "success")")
        }
    }
    
}

extension UserNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresentNotification")
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
