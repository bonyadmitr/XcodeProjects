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
//        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    private let queue = DispatchQueue(label: "qweqweqwe")
    
    private var inProgressOperations = [URL: Operation]()
    private var inProgressBlurOperations = [URL: Operation]()
    
    
    func load(webPhoto: WebPhoto, completion: @escaping (WebPhoto, UIImage?) -> Void) {
//        queue.async {
            self.load2(webPhoto: webPhoto, completion: completion)
//        }
    }
    
    func load2(webPhoto: WebPhoto, completion: @escaping (WebPhoto, UIImage?) -> Void) {
        
//        if let image = ImageDownloaderOperation.cache.object(forKey: webPhoto.url.absoluteString as NSString) {
//            completion(webPhoto, image)
//            return
//        }
//        
//        if let image = ImageDownloaderOperation.cache.object(forKey: webPhoto.thumbnailUrl.absoluteString as NSString) {
//            completion(webPhoto, image)
//            
//            
//            let urlOperation = ImageDownloaderOperation(url: webPhoto.url)
//            urlOperation.completionBlock = { [unowned urlOperation] in
//                if urlOperation.isCancelled {
//                    return
//                }
//                self.inProgressOperations.removeValue(forKey: webPhoto.url)
//                completion(webPhoto, urlOperation.image)
//            }
//            
//            inProgressOperations[webPhoto.url] = urlOperation
//            downloadQueue.addOperation(urlOperation)
//            
//            return
//        }
        
        let blurOperation = ImageBlurOperation()
        
        let thumbnailOperation = ImageDownloaderOperation(url: webPhoto.thumbnailUrl)
        thumbnailOperation.queuePriority = .veryHigh
        thumbnailOperation.completionBlock = { [weak blurOperation] in
            if thumbnailOperation.isCancelled {
                return
            }
            blurOperation?.inputImage = thumbnailOperation.image
            self.inProgressOperations.removeValue(forKey: webPhoto.thumbnailUrl)
            completion(webPhoto, thumbnailOperation.image)
        }
        inProgressOperations[webPhoto.thumbnailUrl] = thumbnailOperation
        downloadQueue.addOperation(thumbnailOperation)
        
        
        
        blurOperation.addDependency(thumbnailOperation)
        thumbnailOperation.queuePriority = .normal
        blurOperation.completionBlock = {
            if blurOperation.isCancelled {
                return
            }
            self.inProgressBlurOperations.removeValue(forKey: webPhoto.thumbnailUrl)
            if blurOperation.resultImage == nil {
                return
            }
            
            completion(webPhoto, blurOperation.resultImage)
        }
        inProgressBlurOperations[webPhoto.thumbnailUrl] = blurOperation
        downloadQueue.addOperation(blurOperation)
        
        
        
        let urlOperation = ImageDownloaderOperation(url: webPhoto.url)
        urlOperation.addDependency(thumbnailOperation)
        urlOperation.addDependency(blurOperation)
        thumbnailOperation.queuePriority = .veryLow
        urlOperation.completionBlock = {
            if urlOperation.isCancelled {
                return
            }
            self.inProgressOperations.removeValue(forKey: webPhoto.url)
            completion(webPhoto, urlOperation.image)
        }
        
        inProgressOperations[webPhoto.url] = urlOperation
//        downloadQueue.addOperation(urlOperation)
        
        downloadQueue.addOperations([urlOperation], waitUntilFinished: false)
    }
    
    func cancel(webPhoto: WebPhoto) {
//        queue.async {
            
            //        inProgressOperations[webPhoto.thumbnailUrl]?.cancel()
            //        inProgressOperations[webPhoto.url]?.cancel()
            
            //        inProgressOperations[webPhoto.thumbnailUrl]!.cancel()
            self.inProgressOperations.removeValue(forKey: webPhoto.thumbnailUrl)?.cancel()
            //        inProgressOperations[webPhoto.url]!.cancel()
            self.inProgressBlurOperations.removeValue(forKey: webPhoto.thumbnailUrl)?.cancel()
            self.inProgressOperations.removeValue(forKey: webPhoto.url)?.cancel()
            
            
        
//        if let op1 = self.inProgressOperations.removeValue(forKey: webPhoto.url) {
//            op1.cancel()
//            
//            if let op2 = self.inProgressBlurOperations.removeValue(forKey: webPhoto.thumbnailUrl) {
//                op2.cancel()
//                op1.removeDependency(op2)
//            } 
//            
//            
//        }
//        
//        }

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

final class ImageBlurOperation: Operation {
    
    var inputImage: UIImage?
    var resultImage: UIImage?
    
    override func main() {
        guard !isCancelled, let image = inputImage else {
            return
        }
        
        //resultImage = blurEffect(image: image)
        resultImage = image.grayScaleImage
    }
    
    private func blurEffect(image: UIImage) -> UIImage? {
        
        guard
            let gaussianFilter = CIFilter(name: "CIGaussianBlur"),
            let cropFilter = CIFilter(name: "CICrop"),
            let inputImage = CIImage(image: image),
            !isCancelled
        else {
            return nil
        }
        
        gaussianFilter.setValue(1, forKey: kCIInputRadiusKey)
        gaussianFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard !isCancelled, let gaussianImage = gaussianFilter.outputImage else {
            return nil
        }
        
        cropFilter.setValue(gaussianImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: inputImage.extent), forKey: "inputRectangle")
        
        
        guard !isCancelled, let croppedImage = cropFilter.outputImage else {
            return nil
        }
        
        return UIImage(ciImage: croppedImage)
    }
}

extension UIImage {
    func mask(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }
        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.draw(cgImage, in: rect)
        context.clip(to: rect, mask: cgImage)
        context.addRect(rect)
        context.drawPath(using: .fill)
        let coloredImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImg
    }
    
    var grayScaleImage: UIImage? {
        /// Selim's method
        guard let cgImage = cgImage,
            let context = CGContext(data: nil,
                                    width: Int(size.width),
                                    height: Int(size.height),
                                    bitsPerComponent: 8,
                                    bytesPerRow: 0,
                                    space: CGColorSpaceCreateDeviceGray(),
                                    bitmapInfo: CGImageAlphaInfo.none.rawValue)
            else { return nil }
        
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.draw(cgImage, in: imageRect)
        
        guard let imageRef = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: imageRef)
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
