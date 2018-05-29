//
//  Structures.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 09.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import MapKit

struct CordinateWithRadiuSstruct {
    var latitude: Double
    var longitude: Double
    var radius: Double
}

struct CordinateWithPlaceInfoStruct {
    var latitude: Double
    var longitude: Double
    var name: String
    var address: String
}


struct AnnotationDataStruct {
    let placeName: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(placeName: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.placeName = placeName
        self.address = address
        self.coordinate = coordinate
    }
}

struct Constants {
    static let key = "AIzaSyBxgfC_wz5EuyEnYmL2_8VcIJ-Amqo61Go"
    static let baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
}
