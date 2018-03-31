//
//  URLs.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 01/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

enum PostUrls: UrlsBase {
    private static let api = try! "http://jsonplaceholder.typicode.com".asURL()
    
    static let all = api +/ "posts"
    static func one(id: Int) -> URL {
        return all +/ String(id)
    }
}
