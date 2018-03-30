//
//  WeatherForecastStorage.swift
//  WeatherApp
//
//  Created by Yaroslav Bondar on 09.02.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import PromiseKit
import RealmSwift

protocol WeatherForecastStorage {
    func getAll() -> Promise<[WeatherForecastRealm]>
    func save(_ objects: [WeatherForecastRealm]) -> Promise<[WeatherForecastRealm]>
}

class WeatherForecastStorageRealm: RealmGetAll, RealmSaveMany, WeatherForecastStorage {
    typealias Entity = WeatherForecastRealm
}
