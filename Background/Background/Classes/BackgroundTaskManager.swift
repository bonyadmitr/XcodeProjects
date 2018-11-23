//
//  BackgroundTaskManager.swift
//  Background
//
//  Created by Bondar Yaroslav on 7/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class BackgroundTaskManager {
    
    static let shared = BackgroundTaskManager()
    
    private var backgroundTaskId = UIBackgroundTaskInvalid /// == 0
    
    let timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
    
    init() {
        timer.schedule(deadline: .now(), repeating: .seconds(3))
        timer.setEventHandler {
            DispatchQueue.main.async {
                debugLog("- backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
            }
        }
        timer.resume()
    }
    
    func beginBackgroundTask() {
        guard backgroundTaskId == UIBackgroundTaskInvalid else {
            return
        }
        
        backgroundTaskId = UIApplication.shared.beginBackgroundTask { [weak self] in
            debugLog("BACKGROUND: expirationHandler")
            self?.endBackgroundTask()
        }
        
        debugLog("BACKGROUND: Task \(backgroundTaskId) has been added")
    }
    
    func endBackgroundTask() {
        guard backgroundTaskId != UIBackgroundTaskInvalid else {
            return
        }
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
        debugLog("BACKGROUND: Task \(backgroundTaskId) has been ended")
        backgroundTaskId = UIBackgroundTaskInvalid
    }
    
    /// backgroundTimeRemaining will be restarted automatically when enter foreground
    func restartBackgroundTask() {
        endBackgroundTask()
        beginBackgroundTask()
    }
    
    ///1.79769313486232E+308 means infinite time
    var backgroundTimeRemaining: TimeInterval {
        return UIApplication.shared.backgroundTimeRemaining
    }
    
    func printBackgroundTimeRemaining() {
        DispatchQueue.main.async {
            debugLog("BACKGROUND backgroundTimeRemaining: \(self.backgroundTimeRemaining)")
        }
    }
}
