//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import Alamofire

protocol WeatherClient {
    func current(for text: String, params: [String: Any]) -> Promise<WeatherCurrent>
    func forecast(for text: String, params: [String: Any]) -> Promise<WeatherForecastResult>
}

final class WeatherClientImp: WeatherClient {
    
    func current(for text: String, params: [String: Any]) -> Promise<WeatherCurrent> {
        return request(URLs.Weather.current, parameters: params)
            .validate()
            .responseObject()
    }
    
    func forecast(for text: String, params: [String: Any]) -> Promise<WeatherForecastResult> {
        return request(URLs.Weather.forecast, parameters: params)
            .validate()
            .responseObject()
    }
}
