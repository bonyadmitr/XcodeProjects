//
//  NSFileCoordinator+Coordinate.swift
//  Depo_LifeTech
//
//  Created by Bondar Yaroslav on 4/21/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import Foundation

extension NSFileCoordinator {
    func coordinate(readingItemAt url: URL, options: NSFileCoordinator.ReadingOptions = []) throws -> URL {
        var fcError: NSError?
        var resultUrl: URL?
        
        coordinate(readingItemAt: url, options: .forUploading, error: &fcError) { trueUrl in
            resultUrl = trueUrl
        }
        
        if let resultUrl = resultUrl {
            return resultUrl
        } else if let error = fcError {
            throw error
        } else {
            let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])
            throw unknownError
        }
    }
}
