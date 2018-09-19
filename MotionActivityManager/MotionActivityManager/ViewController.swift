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

    var manager: CMMotionActivityManager? = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAcivityAccess { status in
            switch status {
            case .success:
                self.startActivityUpdates()
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

    
    
    func requestAcivityAccess(handler: @escaping AccessStatusHandler) {
        
        guard CMMotionActivityManager.isActivityAvailable() else {
            handler(.denied) /// unavailable
            return
        }
        
        func requestAccess() {
            let manager = CMMotionActivityManager()
            let now = Date()
            manager.queryActivityStarting(from: now, to: now, to: .main) { _, error in
                if let error = error as NSError? {
                    if error.code == CMErrorMotionActivityNotAuthorized.rawValue {
                        handler(.denied)
                    } else { /// some system error.
                        handler(.denied)
                    }
                } else {
                    handler(.success)
                }
            }
            
        }
        
        if #available(iOS 11.0, *) {
            switch CMMotionActivityManager.authorizationStatus() {
            case .authorized:
                handler(.success)
            case .denied, .restricted:
                handler(.denied)
            case .notDetermined:
                requestAccess()
            }
        } else {
            requestAccess()
        }
    }
    
    func startActivityUpdates() {
        let manager = CMMotionActivityManager()
        manager.startActivityUpdates(to: .main) { activity in
            
            guard let activity = activity else {
                return
            }
            
            var modes = Set<String>()
            
            if activity.walking {
                modes.insert("🚶‍")
            }
            
            if activity.running {
                modes.insert("🏃‍")
            }
            
            if activity.cycling {
                modes.insert("🚴‍")
            }
            
            if activity.automotive {
                modes.insert("🚗")
            }
            
            if activity.stationary {
                modes.insert("🛑")
            }
            
            if activity.unknown {
                modes.insert("??")
            }
            
            if modes.isEmpty {
                modes.insert("∅")
            }
            
            log(modes.joined(separator: ", "))
            
        }

    }
}

typealias AccessStatusHandler = (_ status: AccessStatus) -> Void
enum AccessStatus {
    case success
    case denied
}

import CoreMotion

//class MotionActivityManager {
//    private let motionManager = CMMotionActivityManager()
//    private let activityQueue = OperationQueue()
//    
//    
//    
//    func startActivityUpdates(to queue: OperationQueue? = nil, withHandler handler: @escaping CoreMotion.CMMotionActivityHandler) {
//        let queue2 = queue ?? activityQueue
//        motionManager.startActivityUpdates(to: queue2, withHandler: handler)
//    }
//}

