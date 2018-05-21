//
//  OCUser.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 29.04.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Foundation
import ObjectMapper


class OCUser: OCEntity {
    
    var id : String?
    var email : String = ""
    var fullName : String = ""
    var password : String?
    var tutorId : String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
 
    // Mappable
    func mapping(map: Map) {
        email           <- map["email"]
        fullName        <- map["fullName"]
        id              <- map["id"]
        password        <- map["password"]
        tutorId         <- map["tutorId"]
    }
}








