//
//  Photo.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 29/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import ObjectMapper

struct Photo: Mappable {
    
    var id: String = ""
    var farm: Int = 0
    var server: String = ""
    var secret: String = ""
    var owner: String = ""
    
    var url: URL? {
        guard let url = try? "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg".asURL() else {
            return nil
        }
        return url
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["photos.photo.0.id"]
        farm <- map["photos.photo.0.farm"]
        server <- map["photos.photo.0.server"]
        secret <- map["photos.photo.0.secret"]
        owner <- map["photos.photo.0.owner"]
    }
}
