//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import Alamofire

///WeatherRemote
class WeatherService {
    
    let forecastStorage: WeatherForecastStorage
    let client: WeatherClient
    
    init(forecastStorage: WeatherForecastStorage = WeatherForecastStorageRealm(),
         client: WeatherClient = WeatherClientImp()
    ) {
        self.forecastStorage = forecastStorage
        self.client = client
    }
    
    static let shared = WeatherService()
    
    private func params(for text: String) -> [String: Any] {
        return ["units": "metric",
                "APPID": URLs.Weather.key,
                "q": text]
    }
    
    func current(for text: String) -> Promise<WeatherCurrent> {
        return client.current(for: text, params: params(for: text))
    }
    
    /// handler call 2 times: 1st from cach and 2ed from api
    func forecast(for text: String, handler: @escaping ([WeatherForecast]) -> Void) {
        _ = firstly {
            forecastStorage.getAll()
        }.then { weatherForecastRealm -> Promise<WeatherForecastResult> in
            let weatherForecast = weatherForecastRealm.map { $0.simple }
            handler(weatherForecast)
            return self.client.forecast(for: text, params: self.params(for: text))
        }.then { result in
            result.list.promise
        }.then { weatherForecast -> Promise<[WeatherForecastRealm]> in
            handler(weatherForecast)
            let realms = weatherForecast.map { $0.dbObject }
            return self.forecastStorage.save(realms)
        }.catchAndLog()
    }
    
    func forecast(for text: String) -> Promise<[WeatherForecast]> {
        return firstly {
            client.forecast(for: text, params: params(for: text))
        }.then { result in
            result.list.promise
        }
    }
}
