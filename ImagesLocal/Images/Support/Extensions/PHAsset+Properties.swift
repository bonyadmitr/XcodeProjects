//
//  PHAsset+Properties.swift
//  Images
//
//  Created by Bondar Yaroslav on 13/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Photos

extension PHAsset {
    
    var resource: PHAssetResource? {
        return PHAssetResource.assetResources(for: self).first
    }
    
    var originalFilename: String? {
        if #available(iOS 9.0, *) {
            return resource?.originalFilename
        } else {
            return value(forKey: "filename") as? String
        }
    }
    
    var uniformTypeIdentifier: String? {
        if #available(iOS 9.0, *) {
            return resource?.uniformTypeIdentifier
        } else {
            return value(forKey: "uniformTypeIdentifier") as? String
        }
    }
    
    var fileSize: Int64? {
        if let unsignedInt64 = resource?.value(forKey: "fileSize") as? UInt64 {
            return Int64(bitPattern: unsignedInt64)
        }
        return nil
    }
}

