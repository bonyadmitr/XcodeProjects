//
//  Attraction.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 22.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class Attraction: Object {
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var placeName: String = ""
    dynamic var address: String = ""
    
}
