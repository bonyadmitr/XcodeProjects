//
//  ImageManager.swift
//  Images
//
//  Created by Bondar Yaroslav on 31/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Photos

typealias ResponseVoid = (ResponseResult<Void>) -> Void
typealias ResponseAsset = (ResponseResult<UIImage>) -> Void

final class ImageManager: NSObject {
    
    private var handler: ResponseVoid?
    
    func saveToDevice(image: UIImage, handler: @escaping ResponseVoid) {
        self.handler = handler
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saved(image:error:contextInfo:)), nil)
    }
    
    @objc private func saved(image: UIImage, error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.handler?(ResponseResult.failed(error))
        } else {
            self.handler?(ResponseResult.success(()))
        }
    }
}

extension ImageManager {
    
    func getLastImageAsset(handler: @escaping ResponseAsset) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            fetchLastPhoto(for: fetchResult, handler: handler)
        } else {
            let error = CustomErrors.text("There is no photos")
            handler(ResponseResult.failed(error))
        }
    }
    
    private func fetchLastPhoto(for fetchResult: PHFetchResult<PHAsset>, handler: @escaping ResponseAsset) {
        
        /// Note that if the request is not set to synchronous
        /// the requestImageForAsset will return both the image
        /// and thumbnail; by setting synchronous to true it
        /// will return just the thumbnail
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .none
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(
            for: fetchResult.object(at: 0),
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFill,
            options: options,
            resultHandler: { (image, _) in
                if let image = image {
                    handler(ResponseResult.success(image))
                } else {
                    let error = CustomErrors.text("System photos error")
                    handler(ResponseResult.failed(error))
                }
        })
    }
}
