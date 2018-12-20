//
//  PHAsset+Properties.swift
//  Images
//
//  Created by Bondar Yaroslav on 13/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Photos

extension PHAsset {
    
    private func mainResource() -> PHAssetResource? {
        return PHAssetResource.assetResources(for: self).first
    }
    
    /// original or iOS one
    func originalFilename() -> String? {
        if #available(iOS 9.0, *) {
            return self.mainResource()?.originalFilename
        } else {
            return value(forKey: "filename") as? String
        }
    }
    
    func filename() -> String? {
        let resources = PHAssetResource.assetResources(for: self)
        guard let mainResource = resources.first else {
            assertionFailure()
            return nil
        }
        let fullFileName: String
        
        if let resource = resources[safe: 1],
            let fileExtension = resource.originalFilename.split(separator: ".").last,
            let dotIndex = mainResource.originalFilename.lastIndex(of: ".") {
            let dotNextIndex = mainResource.originalFilename.index(after: dotIndex)
            
            let fileNameAndDot = String(mainResource.originalFilename.prefix(upTo: dotNextIndex))
            fullFileName = fileNameAndDot + fileExtension
        } else {
            fullFileName = mainResource.originalFilename
        }
        
        return fullFileName
    }
    
    /// will be different for edited photos
    func originalFileSize() -> Int64? {
        return self.mainResource()?.fileSize()
    }
    
    /// edited or original one
    func fileSize() -> Int64? {
        let resources = PHAssetResource.assetResources(for: self)
        let resource = resources[safe: 1] ?? resources.first
        return resource?.fileSize()
    }
    
    func isEdited() -> Bool {
        return PHAssetResource.assetResources(for: self).count > 1
    }
    
    func originalUniformTypeIdentifier() -> String? {
        return getUniformTypeIdentifier(for: self.mainResource())
    }
    
    /// edited or original one
    func uniformTypeIdentifier() -> String? {
        let resources = PHAssetResource.assetResources(for: self)
        let resource = resources[safe: 1] ?? resources.first
        return getUniformTypeIdentifier(for: resource)
    }
    
    /// for public.png image edited image become public.jpeg
    private func getUniformTypeIdentifier(for resource: PHAssetResource?) -> String? {
        if #available(iOS 9.0, *) {
            return resource?.uniformTypeIdentifier
        } else {
            return value(forKey: "uniformTypeIdentifier") as? String
        }
    }
    
    /// optmized to get all values
    func allProperties() -> AllResourcesProperties? {
        let resources = PHAssetResource.assetResources(for: self)
        
        guard let mainResource = resources.first else {
            assertionFailure()
            return nil
        }
        
        let fileName: String
        let resource: PHAssetResource
        
        
        /// mainResource.originalFilename equals something like "IMG_7937.HEIC"
        /// originalResource.originalFilename == "FullSizeRender.jpg"
        /// need take extnesion(jpg) of edited photo(FullSizeRender.jpg) and name+last dot(IMG_7937.) from original image (IMG_7937.HEIC)
        if let originalResource = resources[safe: 1],
            let fileExtension = originalResource.originalFilename.split(separator: ".").last,
            let dotIndex = mainResource.originalFilename.lastIndex(of: ".")
        {
            let dotNextIndex = mainResource.originalFilename.index(after: dotIndex)
            let fileNameAndDot = String(mainResource.originalFilename.prefix(upTo: dotNextIndex))
            fileName = fileNameAndDot + fileExtension
            
            resource = originalResource
        } else {
            fileName = mainResource.originalFilename
            resource = mainResource
        }
        
        let isEdited = resources.count > 1
        let fileSize = resource.fileSize() ?? 0
        let uniformTypeIdentifier = resource.uniformTypeIdentifier
        
        assert(fileSize != 0, "could not get fileSize for resource")
        
        return (fileSize: fileSize,
                uniformTypeIdentifier: uniformTypeIdentifier,
                fileName: fileName,
                isEdited: isEdited)
    }
}

typealias AllResourcesProperties = (fileSize: Int64, uniformTypeIdentifier: String, fileName: String, isEdited: Bool)

extension PHAssetResource {
    func fileSize() -> Int64? {
        return value(forKey: "fileSize") as? Int64
    }
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
