//
//  Event.swift
//  InternHelper
//
//  Created by Yaroslav Bondar on 05.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Foundation
import ObjectMapper


class Event: OCEntity {
    
    var scheduled = NSDate()
    var started = NSDate()
    var ended : String = ""
    var id : String?
    var internId : String = ""
    var tutorId : String = ""
    var type : String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        scheduled   <- map["scheduled"]
        started     <- map["started"]
        ended       <- map["ended"]
        id          <- map["id"]
        internId    <- map["internId"]
        tutorId     <- map["tutorId"]
        type        <- map["type"]
    }
}

//{
//    "scheduled": "2016-07-05",
//    "started": "2016-07-05",
//    "ended": "2016-07-05",
//    "type": "string",
//    "id": "string",
//    "internId": "string",
//    "tutorId": "string"
//}