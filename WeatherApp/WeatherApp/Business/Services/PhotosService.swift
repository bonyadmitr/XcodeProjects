//
//  PhotosService.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 29/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import PromiseKit
import Alamofire

///PhotosRemote
class PhotosService {
    
    static let shared = PhotosService()
    
    func photo(for text: String) -> Promise<Photo> {
        let params: [String: Any] = [
            "method": "flickr.photos.search",
            "api_key": URLs.flickrKey,
            "text": text,
            "sort": "relevance",
            "format": "json",
            "nojsoncallback": "1",
            "per_page": 1
        ]
        
        return request(URLs.flickrApi, parameters: params)
            .validate()
            .responseObject()
    }
    
    func imageUrl(for text: String) -> Promise<URL> {
        return photo(for: text).then { photo in
            Promise(value: photo.url, or: Errors.invalidUrl)
        }
    }
}
