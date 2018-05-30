//
//  Management.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 23.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//


import MapKit
import UIKit
import RealmSwift

class RealmManagement: NSObject {
    let realm = try! Realm()
    
    func save(city: City, attractionsArr: [Attraction]) {
        attractionsArr.forEach{city.attractions.append($0)}
        let citysArr = realm.objects(City.self)
        try! realm.write {
            if citysArr.count > 1 {
                realm.delete(citysArr[0])
            }
            realm.add(city)
        }
        
    }
    
    func getNeededCityAndAttractionsFromRealm() -> City {
        let citysArr = realm.objects(City.self)
        return citysArr[0]
    }
    
}
