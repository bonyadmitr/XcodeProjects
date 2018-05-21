//
//  OCUserCredentials.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 27.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Foundation
import ObjectMapper

class OCUserCredentials: OCEntity {
    
    var id : String?
    var email : String = ""
    var password : String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(email: String, password: String?) {
        self.init()
        self.email = email
        self.password = password
    }
    
    // Mappable
    func mapping(map: Map) {
        email           <- map["email"]
        password        <- map["password"]
    }
}
