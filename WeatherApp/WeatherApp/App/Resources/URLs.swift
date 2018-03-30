//
//  URLs.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 03.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import Foundation

enum URLs {
    static let googlePlacesKey = "AIzaSyDmc393qtAwFYW_zKy7JkBMrZcyOnkaCpI"
    
    //static let googleGeocodingKey = "AIzaSyBOM9Vwyela3f0LbbNx1OLePWbRgXXyV5M"
    static let googleKey = "AIzaSyDJiE9mf0s6w2Dc7oplXwUVuMJkQcEgBL4"
    static let googleApi = try! "https://maps.googleapis.com/maps/api/place/autocomplete/json".asURL()
    
    
    struct Weather {
        static let key = "ab531dac3c6c045e9501f43fa8f0742c"
        static let api = try! "http://api.openweathermap.org/data/2.5".asURL()
        static let current = api +/ "weather"
        static let forecast = api +/ "forecast"
    }
    
    //static let flickrSecret = "3bce4a7e699d0cf3"
    static let flickrKey = "988bb3304a3bae8fb3a3847d9a253b7f"
    static let flickrApi = try! "https://api.flickr.com/services/rest".asURL()
}
