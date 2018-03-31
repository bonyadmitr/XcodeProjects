//
//  Entity.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import ObjectMapper

protocol Entity: Mappable {
    associatedtype ID
    var id: ID { get set }
}
