//
//  ViewController.swift
//  MotionActivityManager
//
//  Created by Bondar Yaroslav on 9/19/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreMotion

/// https://nshipster.com/cmmotionactivity/
/// https://developer.apple.com/documentation/coremotion/cmmotionactivitymanager
class ViewController: UIViewController {

    lazy var activityManager = MotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityManager.requestAcivityAccess { [weak self] status in
            switch status {
            case .success:
                //self?.activityManager.startActivityUpdates()
                self?.activityManager.loadHistory()
            case .denied:
                log("denied")
            }
        }
    }
    
    @IBAction func sendEmail(_ sender: UIBarButtonItem) {
        if FileManager.default.fileExists(atPath: Logger.shared.fileUrl.path),
            let logData = try? Data(contentsOf: Logger.shared.fileUrl)
        {
            let attachment = MailAttachment(data: logData, mimeType: "text/plain", fileName: "logs.txt")
            
            EmailSender.shared.send(message: "",
                                    subject: "MotionActivityManager Test",
                                    to: ["zdaecq@gmail.com"],
                                    attachments: [attachment],
                                    presentIn: self)
        }
    }
}

