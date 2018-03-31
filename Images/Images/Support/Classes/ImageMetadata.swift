//
//  ImageMetadata.swift
//  Images
//
//  Created by Bondar Yaroslav on 13/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import MobileCoreServices
import Photos


/// TARGET IS OFF FOR THIS FILE

///https://developer.apple.com/library/content/qa/qa1895/_index.html
///https://gist.github.com/kwylez/a4b6ec261e52970e1fa5dd4ccfe8898f

/// Generate Metadata Exif for GPS
///https://gist.github.com/nitrag/343fe13f01bb0ef3692f2ae2dfe33e86

/// parse location
/// https://gist.github.com/kkleidal/73401405f7d5fd168d061ad0c154ea18





///USAGE
//
//let qqq = NSMutableDictionary()
//qqq["1111111111111111111"] = "1111111111111111111"
//let path = (info?["PHImageFileURLKey"] as? URL)!
//
//
//let qdata = NSMutableData(data: data)
//
//let z = self.saveImage(qdata, withMetadata: qqq, atPath: path)
//print(z)
//print(CIImage(data: qdata as Data)?.properties ?? "nil")
//print()


final private class Metadata {
    
    /// https://stackoverflow.com/a/42818232
    func saveImage(_ data: NSMutableData, withMetadata metadata: NSMutableDictionary, atPath path: URL) -> Bool {
        //        guard let jpgData = UIImageJPEGRepresentation(image, 1) else {
        //            return false
        //        }
        // make an image source
        guard let source = CGImageSourceCreateWithData(data as CFData, nil), let uniformTypeIdentifier = CGImageSourceGetType(source) else {
            return false
        }
        
        
        
        // make an image destination pointing to the file we want to write
        guard let destination = CGImageDestinationCreateWithData(data, uniformTypeIdentifier, 1, nil) else {
            return false
        }
        
        // add the source image to the destination, along with the metadata
        CGImageDestinationAddImageFromSource(destination, source, 0, metadata)
        
        // and write it out
        return CGImageDestinationFinalize(destination)
    }
    
    
    /// import MobileCoreServices
    /// https://medium.com/@emiswelt/exporting-images-with-metadata-to-the-photo-gallery-in-swift-3-ios-10-66210bbad5d2
    ///
    // Take care when passing the paths. The directory must exist.
    // let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/"
    // let filePath = path + name + ".jpg"
    // try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    // saveToPhotoAlbumWithMetadata(image, filePath: filePath)
    static func saveToPhotoAlbumWithMetadata(_ image: CGImage, filePath: String) {
        
        let cfPath = CFURLCreateWithFileSystemPath(nil, filePath as CFString, CFURLPathStyle.cfurlposixPathStyle, false)
        
        // You can change your exif type here.
        let destination = CGImageDestinationCreateWithURL(cfPath!, kUTTypeJPEG, 1, nil)
        
        // Place your metadata here.
        // Keep in mind that metadata follows a standard. You can not use custom property names here.
        let tiffProperties = [
            kCGImagePropertyTIFFMake as String: "Your camera vendor",
            kCGImagePropertyTIFFModel as String: "Your camera model"
            ] as CFDictionary
        
        let properties = [
            kCGImagePropertyExifDictionary as String: tiffProperties
            ] as CFDictionary
        
        CGImageDestinationAddImage(destination!, image, properties)
        CGImageDestinationFinalize(destination!)
        
        try? PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))
        }
    }

}



