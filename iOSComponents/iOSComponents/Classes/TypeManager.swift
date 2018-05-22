//
//  TypeManager.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 22/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import MobileCoreServices

final class TypeManager {
    
    static func hasSupportedExtension(mimeType: String) -> Bool {
        let type = mimeType as CFString
        
        guard let preferredIdentifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, type, nil)?.takeUnretainedValue()
            else {
                return false
        }
        return UTTypeIsDeclared(preferredIdentifier)
    }
    
    static func mimeType(from fileExtension: String) -> String? {
        guard
            let preferredIdentifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeUnretainedValue(),
            let mimetype = UTTypeCopyPreferredTagWithClass(preferredIdentifier, kUTTagClassMIMEType)?.takeUnretainedValue() as String?
            else {
                return "application/octet-stream"
        }
        return mimetype
    }
    
    /// UTI
    /// https://stackoverflow.com/a/34772517/5893286
    static func utType(from url: URL) -> String? {
        return (try? url.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    static func mimeType(from url: URL) -> String? {
        guard
            let uti = utType(from: url),
            let mimetype = UTTypeCopyPreferredTagWithClass(uti as CFString, kUTTagClassMIMEType)?.takeRetainedValue()
            else {
                return "application/octet-stream"
        }
        return  mimetype as String
    }
    
    static func imageContentType(from url: URL) -> String {
        let type = url.pathExtension.lowercased()
        
        if !type.isEmpty {
            return "image/\(type)"
        } else if let data = try? Data(contentsOf: url) {
            return ImageFormat.get(from: data).contentType
        } else {
            return "image/jpg"
        }
    }
}
