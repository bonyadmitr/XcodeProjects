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

typealias AccessStatusHandler = (_ status: AccessStatus) -> Void
enum AccessStatus {
    case success
    case denied
}

import CoreMotion

final class MotionActivityManager {
    private let motionManager = CMMotionActivityManager()
    private let activityQueue = OperationQueue()
    
    func requestAcivityAccess(handler: @escaping AccessStatusHandler) {
        
        guard CMMotionActivityManager.isActivityAvailable() else {
            handler(.denied) /// unavailable
            return
        }
        
        func requestAccess() {
            /// if you need separate function
            ///let motionManager = CMMotionActivityManager()
            let now = Date()
            motionManager.queryActivityStarting(from: now, to: now, to: .main) { _, error in
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
        motionManager.startActivityUpdates(to: activityQueue) { activity in
            
            guard let activity = activity else {
                return
            }
            
            log(activity.modes)
        }
        
    }
    
    func startActivityUpdates(to queue: OperationQueue? = nil, withHandler handler: @escaping CoreMotion.CMMotionActivityHandler) {
        let queue2 = queue ?? activityQueue
        motionManager.startActivityUpdates(to: queue2, withHandler: handler)
    }
    
    func loadHistory() {
        let firstDate = Date(timeIntervalSince1970: 0)
        motionManager.queryActivityStarting(from: firstDate, to: Date(), to: activityQueue) { activities, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let activities = activities {
                for activity in activities {
                    print(activity.modes)
                }
                print("activities.count", activities.count)
                print("activities startDate", activities.first?.startDate ?? "nil")
            } else {
                print("unknown errro")
            }
        }
    }
}
