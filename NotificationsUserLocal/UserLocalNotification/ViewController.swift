//
//  ViewController.swift
//  UserLocalNotification
//
//  Created by Константин on 12.10.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionTitle = [String]()
    var data = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sectionTitle = ["Default Notifications", "Attachment Notification", "Notification with Action", "Notification with Custom UI"]
        
        data = [
            ["Time Interval Trigger", "Calendar Trigger", "Location Trigger"],
            ["Notification with Image", "Notification with Image Gif", "Notification with Audio", "Notification with Video"],
            ["Set Categories", "Notification with Category 1", "Notification with Category 2", "Notification with Category 3"],
            ["Notification with CustomUI", "Notification with CustomUI and Media Player"]
        ]
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  data[section].count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.addNotificationWithTimeIntervalTrigger()
                break
            case 1:
                UserNotificationManager.shared.addNotificationWithCalendarTrigger()
                break
            case 2:
                UserNotificationManager.shared.addNotificationWithLocationTrigger()
                break
            default: break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.addNotificationWithAttachmentType(type: .image)
                break
            case 1:
                UserNotificationManager.shared.addNotificationWithAttachmentType(type: .imageGif)
                break
            case 2:
                UserNotificationManager.shared.addNotificationWithAttachmentType(type: .audio)
                break
            case 3:
                UserNotificationManager.shared.addNotificationWithAttachmentType(type: .video)
                break
            default: break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.setCategories()
                break
            case 1:
                UserNotificationManager.shared.addNotificationWithCategory1()
                break
            case 2:
                UserNotificationManager.shared.addNotificationWithCategory2()
                break
            case 3:
                UserNotificationManager.shared.addNotificationWithCategory3()
                break
            default: break
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                UserNotificationManager.shared.addLocalCustomUI()
                break
            case 1:
                UserNotificationManager.shared.addCustomUIMediaPlay()
                break
            default: break
            }
        }
    }


}

