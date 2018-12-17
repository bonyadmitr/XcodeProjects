//
//  UTType+FileExtension.swift
//  Images
//
//  Created by Bondar Yaroslav on 2/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

/// TARGET IS OFF FOR THIS FILE
import MobileCoreServices

/// Usage
/**
 if Images.isEqual(fileExtension: url.pathExtension, to: kUTTypeImage) {
    print("This is an image!")
 }
 */
/// https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
/// https://developer.apple.com/documentation/mobilecoreservices/uttype
func isEqual(fileExtension: String, to utType: CFString) -> Bool {
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil), UTTypeConformsTo(uti.takeRetainedValue(), utType)
    {
        return true
    } else {
        return false
    }
}
