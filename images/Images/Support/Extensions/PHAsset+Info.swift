//
//  PHAsset+Info.swift
//  Images
//
//  Created by Bondar Yaroslav on 2/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Photos

extension PHAsset {
    
    static func fileURL(from info: [AnyHashable : Any]?) -> URL? {
        return (info?["PHImageFileURLKey"] as? URL)
    }
    
    static func filename(from info: [AnyHashable : Any]?) -> String? {
        return fileURL(from: info)?.lastPathComponent
    }
    
    ///result is in iCloud, meaning a new request will need to get issued (with networkAccessAllowed set) to get the result
    static func isInCloud(from info: [AnyHashable : Any]?) -> Bool {
        return (info?[PHImageResultIsInCloudKey] as? NSNumber)?.boolValue == true
    }
    
    static func uniformTypeIdentifier(from info: [AnyHashable : Any]?) -> String? {
        return info?["PHImageFileUTIKey"] as? String
    }
}
