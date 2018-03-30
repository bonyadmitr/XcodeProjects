//
//  WeatherRealm.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper

class WeatherCommonRealm: BaseRealmObject {
    
    @objc dynamic var temperature: Double = 0
    @objc dynamic var pressure: Double = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var windSpeed: Double = 0
    @objc dynamic var icon: String = ""
    @objc dynamic var info: String = ""
    
    convenience init(simple: WeatherCommon) {
        self.init()
        temperature = simple.temperature
        pressure = simple.pressure
        humidity = simple.humidity
        windSpeed = simple.windSpeed
        icon = simple.icon
        info = simple.info
    }
    
    var simple: WeatherCommon {
        let s = WeatherCommon()
        s.temperature = temperature
        s.pressure = pressure
        s.humidity = humidity
        s.windSpeed = windSpeed
        s.icon = icon
        s.info = info
        return s
    }
}

final class WeatherCurrentRealm: WeatherCommonRealm {
    @objc dynamic var visibility: Int = 0
    
    convenience init(simple: WeatherCurrent) {
        self.init()
        temperature = simple.temperature
        pressure = simple.pressure
        humidity = simple.humidity
        windSpeed = simple.windSpeed
        icon = simple.icon
        info = simple.info
        visibility = simple.visibility
    }
    
    // TODO: need DRY
    override var simple: WeatherCurrent {
        let s = WeatherCurrent()
        s.temperature = temperature
        s.pressure = pressure
        s.humidity = humidity
        s.windSpeed = windSpeed
        s.icon = icon
        s.info = info
        s.visibility = visibility
        return s
    }
}

final class WeatherForecastRealm: WeatherCommonRealm {
    @objc dynamic var dateInterval: Int = 0
    
    convenience init(simple: WeatherForecast) {
        self.init()
        temperature = simple.temperature
        pressure = simple.pressure
        humidity = simple.humidity
        windSpeed = simple.windSpeed
        icon = simple.icon
        info = simple.info
        dateInterval = simple.dateInterval
    }
    
    override var simple: WeatherForecast {
        let s = WeatherForecast()
        s.temperature = temperature
        s.pressure = pressure
        s.humidity = humidity
        s.windSpeed = windSpeed
        s.icon = icon
        s.info = info
        s.dateInterval = dateInterval
        return s
    }
}

extension WeatherForecast {
    var dbObject: WeatherForecastRealm {
        return WeatherForecastRealm(simple: self)
    }
}
