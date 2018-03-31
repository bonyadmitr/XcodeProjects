//
//  ViewController.swift
//  NotificationsLocalActions
//
//  Created by zdaecqze zdaecq on 24.08.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doNothingAction = UIMutableUserNotificationAction()
        doNothingAction.identifier = "justInform"
        doNothingAction.title = "Thanks, Got it"
        doNothingAction.activationMode = .background
        doNothingAction.isDestructive = false
        doNothingAction.isAuthenticationRequired = false
        
        
        let remindAction = UIMutableUserNotificationAction()
        remindAction.identifier = "remindAgain"
        remindAction.title = "Remind in 30 min"
        remindAction.activationMode = .background
        remindAction.isDestructive = false
        remindAction.isAuthenticationRequired = false
        if #available(iOS 9.0, *) {
            remindAction.parameters = [
                "string": "some string",
                "int": 10
            ]
        } else {
            // Fallback on earlier versions
        }
        
        
        let completedAction = UIMutableUserNotificationAction()
        completedAction.identifier = "completed"
        completedAction.title = "Completed task"
        completedAction.activationMode = .background
        completedAction.isDestructive = false
        completedAction.isAuthenticationRequired = true
        
        
        let deleteAction = UIMutableUserNotificationAction()
        deleteAction.identifier = "delete"
        deleteAction.title = "Delete reminder View reminder from the code"
        deleteAction.activationMode = .background
        deleteAction.isDestructive = true
        deleteAction.isAuthenticationRequired = true
        
        
        let reminderCategory = UIMutableUserNotificationCategory()
        reminderCategory.identifier = "quickAction"
        reminderCategory.setActions([doNothingAction, remindAction, completedAction, deleteAction], for: .default)//4
        reminderCategory.setActions([remindAction, deleteAction], for: .minimal) //two actions only
        
        let categories = Set<UIUserNotificationCategory>(arrayLiteral: reminderCategory)
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: categories)
        
        
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        
        
        updateUI()
    }

    @IBAction func actionButton(_ sender: UIButton) {
        
        let notification = UILocalNotification()
        
        notification.fireDate = fixedNotificationDate(Date())
        notification.timeZone = TimeZone.current
        notification.applicationIconBadgeNumber = 1
        notification.alertBody = "Start cooking dinner"
        
        notification.alertAction = "View reminder from the code"
        notification.category = "quickAction"
        //notification.repeatInterval = .Minute
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func fixedNotificationDate(_ dateToFix: Date) -> Date {
        var dateComponents = (Calendar.current as NSCalendar).components([.day, .month, .year, .hour, .minute, .second], from: dateToFix)
        
        dateComponents.second = dateComponents.second! + 10
        let fixedDate = Calendar.current.date(from: dateComponents)!
        return fixedDate
    }
    
    func updateUI() {
        guard let currentSettings = UIApplication.shared.currentUserNotificationSettings else {
            return
        }
        
        //if both badge & alert notification is active then display all the UI
        if currentSettings.types == [.badge, .alert] {
            button.isHidden = false
        
        //If user disables alert notification
        } else if currentSettings.types == .badge {
            // ???? false, need to test
            button.isHidden = false
            
        //if user had denied permission or closed notification then hide all of the UI.
        } else if currentSettings.types == UIUserNotificationType() {
            button.isHidden = true
        }
    }
}
