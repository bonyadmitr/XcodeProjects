//
//  JSONReader.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 08.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import UIKit

class JSONReader: NSObject {
    
    class func jsonReader(usableData: Data) -> [CordinateWithPlaceInfoStruct]? {
        var resultArr: [CordinateWithPlaceInfoStruct] = []
        do {
            if let json = try JSONSerialization.jsonObject(with: usableData, options: []) as? [String: AnyObject] {
        
                guard
                    let results = json["results"] as? [[String: Any]],
                    let status = json["status"] as? String,
                    status == "OK"
                    else {return nil}
                
                for city in results {
                    guard
                        let geometry = city["geometry"] as? [String: Any],
                        let vicinity = city["vicinity"] as? String,
                        let name = city["name"] as? String,
                        let location = geometry["location"] as? [String: Any],
                        let lat = location["lat"] as? Double,
                        let lng = location["lng"] as? Double
                        else {return nil}
                    
                    let cordinateResult = CordinateWithPlaceInfoStruct.init(latitude: lat, longitude: lng, name: name, address: vicinity)
                    resultArr.append(cordinateResult)
                }
            }
        } catch {
            print(error)
            return nil
            
        }
        return resultArr
    }
    
    
}
