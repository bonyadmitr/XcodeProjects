//
//  MotionActivityManager.swift
//  MotionActivityManager
//
//  Created by Bondar Yaroslav on 9/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreMotion

typealias AccessStatusHandler = (_ status: AccessStatus) -> Void
enum AccessStatus {
    case success
    case denied
}

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
