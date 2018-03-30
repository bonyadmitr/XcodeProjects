//
//  Weather.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import ObjectMapper

class WeatherCommon: Mappable {
    
    var temperature: Double = 0
    var pressure: Double = 0
    var humidity: Int = 0
    var windSpeed: Double = 0
    var icon: String = ""
    var info: String = ""
    
    init() {}

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        temperature <- map["main.temp"]
        pressure <- map["main.pressure"]
        humidity <- map["main.humidity"]
        windSpeed <- map["wind.speed"]
        icon <- map["weather.0.icon"]
        info <- map["weather.0.description"]
    }
}

class WeatherCurrent: WeatherCommon {
    var visibility: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        visibility <- map["visibility"]
    }
}

class WeatherForecast: WeatherCommon, Promisable {
    var dateInterval: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dateInterval <- map["dt"]
    }
}

class WeatherForecastResult: Mappable {
    var list: [WeatherForecast] = []
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        list <- map["list"]
    }
}
