//
//  BackendError.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 03.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

//import ObjectMapper
//
//struct BackendError: Error {
//    var status: Int
//    var code: String
//    var localized: String {
//        print("status", status)
//        print("code", code)
//        return NSLocalizedString(code, comment: "")
//    }
//}
//
//extension BackendError: Mappable {
//    init?(map: Map) {
//        let requiredProperties = ["status", "code"]
//        let containsAllProps = requiredProperties.contains(where: { map[$0].isKeyPresent == false }) == false
//        guard containsAllProps else {
//            return nil
//        }
//        self.init(status: 0, code: "")
//    }
//    
//    mutating func mapping(map: Map) {
//        status <- map["status"]
//        code <- map["code"]
//    }
//}
