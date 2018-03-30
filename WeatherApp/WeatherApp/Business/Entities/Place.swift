//
//  Place.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 21/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

class Place: NSObject, NSCoding {
    let city: String
    let country: String
    let full: NSAttributedString
    
    init(city: String, country: String, full: NSAttributedString) {
        self.city = city
        self.country = country
        self.full = full
    }
    
    // MARK: - NSCoding
    
    private enum Keys {
        static let city = "city"
        static let country = "country"
        static let full = "full"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let city = aDecoder.decodeObject(forKey: Keys.city) as? String,
            let country = aDecoder.decodeObject(forKey: Keys.country) as? String,
            let full = aDecoder.decodeObject(forKey: Keys.full) as? String
            else { return nil }
        self.init(city: city, country: country, full: NSAttributedString(string: full))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: Keys.city)
        aCoder.encode(country, forKey: Keys.country)
        aCoder.encode(full.string, forKey: Keys.full)
    }
}
