//
//  ImageOperationsManager.swift
//  ImageOperationsManager
//
//  Created by Bondar Yaroslav on 10/13/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ImageOperationsManager {
    
    static let shared = ImageOperationsManager()
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        //queue.name = "Download queue"
        //queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    private var inProgressOperations = [URL: Operation]()
    
    
    func load(webPhoto: WebPhoto, completion: @escaping (WebPhoto, UIImage?) -> Void) {
        
        if let image = ImageDownloaderOperation.cache.object(forKey: webPhoto.url.absoluteString as NSString) {
            completion(webPhoto, image)
            return
        }
        
        if let image = ImageDownloaderOperation.cache.object(forKey: webPhoto.thumbnailUrl.absoluteString as NSString) {
            completion(webPhoto, image)
            
            
            let urlOperation = ImageDownloaderOperation(url: webPhoto.url)
            urlOperation.completionBlock = {
                if urlOperation.isCancelled {
                    return
                }
                self.inProgressOperations.removeValue(forKey: webPhoto.url)
                completion(webPhoto, urlOperation.image)
            }
            
            inProgressOperations[webPhoto.url] = urlOperation
            downloadQueue.addOperation(urlOperation)
            
            return
        }
        
        let thumbnailOperation = ImageDownloaderOperation(url: webPhoto.thumbnailUrl)
        thumbnailOperation.completionBlock = {
            if thumbnailOperation.isCancelled {
                return
            }
            self.inProgressOperations.removeValue(forKey: webPhoto.thumbnailUrl)
            completion(webPhoto, thumbnailOperation.image)
        }
        inProgressOperations[webPhoto.thumbnailUrl] = thumbnailOperation
        downloadQueue.addOperation(thumbnailOperation)
        
        let urlOperation = ImageDownloaderOperation(url: webPhoto.url)
        urlOperation.addDependency(thumbnailOperation)
        urlOperation.completionBlock = {
            if urlOperation.isCancelled {
                return
            }
            self.inProgressOperations.removeValue(forKey: webPhoto.url)
            completion(webPhoto, urlOperation.image)
        }
        inProgressOperations[webPhoto.url] = urlOperation
        downloadQueue.addOperation(urlOperation)
    }
    
    func cancel(webPhoto: WebPhoto) {
//        inProgressOperations[webPhoto.thumbnailUrl]?.cancel()
//        inProgressOperations[webPhoto.url]?.cancel()
        
//        inProgressOperations[webPhoto.thumbnailUrl]!.cancel()
        inProgressOperations.removeValue(forKey: webPhoto.thumbnailUrl)?.cancel()
//        inProgressOperations[webPhoto.url]!.cancel()
        inProgressOperations.removeValue(forKey: webPhoto.url)?.cancel()
    }
}


extension URLSession {
    static let sharedCustom: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        return URLSession(configuration: config)
    }()
}

final class ImageDownloaderOperation: Operation {
    
    static let cache = NSCache<NSString, UIImage>()
    
    private let semaphore = DispatchSemaphore(value: 0)
    private let url: URL
    private var task: URLSessionTask?
    
    var image: UIImage?
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        let task = URLSession.sharedCustom.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data), let `self` = self {
                self.image = image
                ImageDownloaderOperation.cache.setObject(image, forKey: self.url.absoluteString as NSString)
            }
            
            
            self?.semaphore.signal()
        }
        task.resume()
        self.task = task
        
        semaphore.wait()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
        semaphore.signal()
    }
}

struct WebPhoto: Decodable {
    let thumbnailUrl: URL
    let url: URL
}
extension WebPhoto: Equatable {
    static func == (lhs: WebPhoto, rhs: WebPhoto) -> Bool {
        return lhs.thumbnailUrl == rhs.thumbnailUrl && lhs.url == rhs.url
    }
}
