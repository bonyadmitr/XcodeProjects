//
//  OCToken.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 22.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import ObjectMapper


class OCToken: Mappable {
    var id = ""
    var ttl = ""
    var created = NSDate()
    
    init(id: String) {
        self.id  = id
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        ttl     <- map["ttl"]
        created <- map["created"]
    }
}