//
//  CacheManager.swift
//  ImageOperationsManager
//
//  Created by Bondar Yaroslav on 10/14/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol DataPresentable: class {
    var data: Data? { get }
    init?(data: Data)
}

extension UIImage: DataPresentable {
    var data: Data? {
        return UIImageJPEGRepresentation(self, 0.9)
    }
}

typealias VoidHnadler = () -> Void

import UIKit
/// static not supported
let ImageCacheManager = CacheManager<UIImage>()

/// https://github.com/onevcat/Kingfisher/blob/master/Sources/ImageCache.swift
final class CacheManager<T: DataPresentable> {
    
    private let fileManager = FileManager.default
    private let fileManagerQueue = DispatchQueue(label: "fileManagerQueue")
    private let diskCacheFolderName = "CacheManager"
    private let diskCachePath: String
    
    private let memotyCache = NSCache<NSString, T>()
    
    var maxMemoryCost: Int = 0 {
        didSet {
            memotyCache.totalCostLimit = maxMemoryCost
        }
    }
    
    init() {
        if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            diskCachePath = (cacheDirectory as NSString).appendingPathComponent(diskCacheFolderName)
        } else {
            assertionFailure()
            diskCachePath = ""
        }
    }
    
    func getObject(forKey key: String, completionHandler: ((T?) -> Void)?) {
        fileManagerQueue.async {
            if let object = self.memotyCache.object(forKey: key as NSString) {
                completionHandler?(object)
            } else {
                let filePath = self.pathInDiskCacheFolder(for: key)
                if let data = try? NSData(contentsOfFile: filePath) as Data {
                    let object = T(data: data)
                    completionHandler?(object)
                } else {
                    completionHandler?(nil)
                }
            }
        }
    }
    
    func store(object: T, forKey key: String, toMemoty: Bool, toDisk: Bool, completionHandler: VoidHnadler? = nil) {
        fileManagerQueue.async {
            if toMemoty {
                self.memotyCache.setObject(object, forKey: key as NSString)
            }
            
            if toDisk, let data = object.data {
                /// we need check on every write bcz system can clear it
                self.createCacheFolderIfNeed()
                
                let filePath = self.pathInDiskCacheFolder(for: key)
                self.fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
                completionHandler?()
            }
        }
    }
    
    func removeObject(forKey key: String, fromMemory: Bool, fromDisk: Bool, completionHandler: VoidHnadler? = nil) {
        fileManagerQueue.async{
            if fromMemory {
                self.memotyCache.removeObject(forKey: key as NSString)
            }
            
            if fromDisk {
                let filePath = self.pathInDiskCacheFolder(for: key)
                do {
                    try self.fileManager.removeItem(atPath: filePath)
                } catch {
                    print(error.localizedDescription)
                    assertionFailure()
                }
                completionHandler?()
            }
        }
    }
    
    private func createCacheFolderIfNeed() {
        if !self.fileManager.fileExists(atPath: self.diskCachePath) {
            do {
                try self.fileManager.createDirectory(atPath: self.diskCachePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                assertionFailure()
            }
        }
    }
    
    private func pathInDiskCacheFolder(for key: String) -> String {
        let fileName = Data(key.utf8).base64EncodedString() //key /// md5
        return (diskCachePath as NSString).appendingPathComponent(fileName)
    }
    
    
}
