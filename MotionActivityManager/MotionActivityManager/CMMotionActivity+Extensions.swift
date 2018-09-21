//
//  CMMotionActivity+Extensions.swift
//  MotionActivityManager
//
//  Created by Bondar Yaroslav on 9/21/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreMotion

extension CMMotionActivity {
    var modes: String {
        var modes = Set<String>()
        
        if walking {
            modes.insert("🚶‍")
        }
        
        if running {
            modes.insert("🏃‍")
        }
        
        if cycling {
            modes.insert("🚴‍")
        }
        
        if automotive {
            modes.insert("🚗")
        }
        
        if stationary {
            modes.insert("🛑")
        }
        
        if unknown {
            modes.insert("??")
        }
        
        if modes.isEmpty {
            modes.insert("∅")
        }
        
        return modes.joined(separator: ", ")
    }
}

//            var modes = Set<String>()
//            
//            if activity.walking {
//                modes.insert("🚶‍")
//            }
//            
//            if activity.running {
//                modes.insert("🏃‍")
//            }
//            
//            if activity.cycling {
//                modes.insert("🚴‍")
//            }
//            
//            if activity.automotive {
//                modes.insert("🚗")
//            }
//            
//            if activity.stationary {
//                modes.insert("🛑")
//            }
//            
//            if activity.unknown {
//                modes.insert("??")
//            }
//            
//            if modes.isEmpty {
//                modes.insert("∅")
//            }
