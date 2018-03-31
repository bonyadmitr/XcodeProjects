//
//  DefaultRouter.swift
//  Networking
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import PromiseKit

struct DefaultRouter<T: Mappable>: RouterAll {
    typealias Model = T
    let baseUrl: String
}
