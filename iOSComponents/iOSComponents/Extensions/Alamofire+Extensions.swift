//
//  AlamofireExtentions.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 21.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

// MARK: Need to import Alamofire framework to project

import Alamofire
//
///*Alamofire.request(...).responseObject {...}.responseDebugPrint()*/
extension Alamofire.Request {
    func responseDebugPrint() -> Self {
        return responseJSON() { response in
            if let  JSON: AnyObject = response.result.value,
                JSONData = try? NSJSONSerialization.dataWithJSONObject(JSON, options: .PrettyPrinted),
                prettyString = NSString(data: JSONData, encoding: NSUTF8StringEncoding) {
                print(prettyString)
            } else if let error = response.result.error {
                print("Error Debug Print: \(error.localizedDescription)")
                if let data = response.data where response.data?.length != 0 {
                    let errorJSONString = NSString(data: data, encoding:NSUTF8StringEncoding)
                    print(errorJSONString)
                }
            }
        }
    }
}
