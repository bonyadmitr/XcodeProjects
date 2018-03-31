//
//  PhotoViewerController.swift
//  Images
//
//  Created by Bondar Yaroslav on 10/02/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Photos

/// need send image or imageView for long downloads
/// PHAdjustmentData

/// edit album
/// https://stackoverflow.com/questions/31239513/how-can-i-edit-or-rename-a-phassetcollection-localizedtitle


/// check all
/// https://habrahabr.ru/post/318810/

final class PhotoViewerController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    var asset: PHAsset?
    private var requestID: PHImageRequestID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = false
//        }
        
        PHPhotoLibrary.shared().register(self)
        
        progressView.progress = 0
        imageScrollView.delegate = self
        
        updateStillImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageScrollView.updateZoom()
    }
    
    deinit {
        print("- deinit PhotoViewerController")
        /// optimization for big images
        if let requestID = requestID {
            PHImageManager.default().cancelImageRequest(requestID)
        }
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func updateStillImage() {
        guard let asset = asset else {
            return
        }
        
        favoriteBarButton.title = asset.isFavorite ? "♥︎" : "♡"
        
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        //options.isSynchronous = true
        
        /// for iCloud only
        /// Handler might not be called on the main queue, so re-dispatch for UI work.
        options.progressHandler = { progress, _, _, _ in
            DispatchQueue.main.sync {
                self.progressView.progress = Float(progress)
            }
        }
        
        progressView.isHidden = false
        //progressView.progress = 0 /// need?
        requestID = PHImageManager.default().requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFit,
            options: options,
            resultHandler: { image, info in
                /// Hide the progress view now the request has completed.
                self.progressView.isHidden = true
                
                guard let image = image else {
                    return
                }
                self.imageScrollView.image = image
                self.imageScrollView.updateZoom()
        })
        
        
        printSize()
        //printMetadata()
    }
    
    func printSize() {
        guard let asset = asset else {
            return
        }
        
        print("creationDate", asset.creationDate ?? "nil")
        print("modificationDate", asset.modificationDate ?? "nil")
        
        if let originalFilename = asset.originalFilename {
            title = originalFilename
        }
        
        print(asset.location ?? "location nil")
        
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        //options.isSynchronous = true
        options.resizeMode = .exact
        
        PHImageManager.default().requestImageData(for: asset, options: options) { (data, uniformTypeIdentifier, orientation, info) in
            
            if let type = uniformTypeIdentifier {
                print("uniformTypeIdentifier:", type)
            }
            
            if let data = data {
                print(data.formattedSize)
                
                if let fileName = PHAsset.filename(from: info) {
                    print("iOS fileName", fileName)
                }
                
                /// metadata
//                if let ciImage = CIImage(data: data) {
//                    print(ciImage.properties)
//                }

            }
        }
    }
    
    @IBAction func actionDeleteBarButton(_ sender: UIBarButtonItem) {
        removeAsset()
    }
    
    @IBAction func actionFavoriteBarButton(_ sender: UIBarButtonItem) {
        toggeleFavoriteAsset()
    }
    
    @IBAction func actionFilterBarButton(_ sender: UIBarButtonItem) {
        applyFilter()
    }
    
    private func printMetadata() {
        guard let asset = asset else {
            return
        }
        
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true
        
        asset.requestContentEditingInput(with: options) { contentEditingInput, _ in
            guard
                let url = contentEditingInput?.fullSizeImageURL,
                let fullImage = CIImage(contentsOf: url)
            else {
                return
            }
            print(fullImage.properties)
        }

    }
    
    // TODO: TODO: clear
    private func applyFilter() {
        guard let asset = asset else {
            return
        }
        
        let formatIdentifier = Bundle.main.bundleIdentifier!
        let formatVersion = "1.0"
        let filterName = "CISepiaTone"
        //let filterName = "CIPhotoEffectChrome"
        
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true
        options.canHandleAdjustmentData = {
            $0.formatIdentifier == formatIdentifier && $0.formatVersion == formatVersion
        }
        
        asset.requestContentEditingInput(with: options) { input, info in
//            guard
//                let url = contentEditingInput?.fullSizeImageURL,
//                let fullImage = CIImage(contentsOf: url)
//            else {
//                return
//            }
            
            guard let input = input
                else { fatalError("can't get content editing input: \(info)") }
            
            // This handler gets called on the main thread; dispatch to a background queue for processing.
            DispatchQueue.global(qos: .userInitiated).async {
                
                // Create adjustment data describing the edit.
                let adjustmentData = PHAdjustmentData(formatIdentifier: formatIdentifier,
                                                      formatVersion: formatVersion,
                                                      data: filterName.data(using: .utf8)!)
                
                /* NOTE:
                 This app's filter UI is fire-and-forget. That is, the user picks a filter,
                 and the app applies it and outputs the saved asset immediately. There's
                 no UI state for having chosen but not yet committed an edit. This means
                 there's no role for reading adjustment data -- you do that to resume
                 in-progress edits, and this sample app has no notion of "in-progress".
                 
                 However, it's still good to write adjustment data so that potential future
                 versions of the app (or other apps that understand our adjustement data
                 format) could make use of it.
                 */
                
                // Create content editing output, write the adjustment data.
                let output = PHContentEditingOutput(contentEditingInput: input)
                output.adjustmentData = adjustmentData

                self.applyPhotoFilter(filterName, input: input, output: output) {
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetChangeRequest(for: asset)
                        request.contentEditingOutput = output
                    }, completionHandler: { success, error in
                        if !success { print("can't edit asset: \(String(describing: error))") }
                    })
                }
            }
        }
        
    }
    
    /// CHECK
    func revertAsset() {
        guard let asset = asset else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: asset)
            request.revertAssetContentToOriginal()
        }, completionHandler: { success, error in
            if !success {
                print("can't revert asset: \(String(describing: error))")
            }
        })
    }
    
    
    func toggeleFavoriteAsset() {
        print("self.asset 1", self.asset?.isFavorite == true ? "♥︎" : "♡")
        
        guard let asset = asset else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: asset)
            request.isFavorite = !asset.isFavorite
//            request.creationDate = Date()
//            request.isHidden = !asset.isHidden
            request.location = nil
        }, completionHandler: { success, error in
            if success {
                DispatchQueue.main.sync {
                    print("self.asset 2", self.asset?.isFavorite == true ? "♡": "♥︎")
                    print("asset", asset.isFavorite ? "♡": "♥︎")
                    self.favoriteBarButton.title = asset.isFavorite ? "♡": "♥︎"
                }
            } else if let error = error {
                print("can't set favorite: \(error.localizedDescription)")
            } else {
                print(CustomErrors.unknown())
            }
        })
        
    }
    
    func removeAsset() {
        /// https://developer.apple.com/documentation/photos/phassetcollection
        guard let asset = asset else {
            return
        }
        
        let completion = { (success: Bool, error: Error?) -> Void in
            if success {
                print("deleted asset")
                /// Use unregisterChangeObserver or
                /// handle in PHPhotoLibraryChangeObserver with objectAfterChanges == nil
                PHPhotoLibrary.shared().unregisterChangeObserver(self)
                DispatchQueue.main.sync {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            } else if let error = error {
                print("can't remove asset: \(error.localizedDescription)")
            } else {
                print(CustomErrors.unknown())
            }
        }
        
        let fetchResult = PHAssetCollection.fetchAssetCollectionsContaining(asset, with: .smartAlbum, options: nil)
        
        if fetchResult.count == 0 {
            // Delete asset from library
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }, completionHandler: completion)
            
        } else {
            /// add DispatchGroup handler !!!
            fetchResult.enumerateObjects { (collection, _, _) in
                // Remove asset from album
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCollectionChangeRequest(for: collection)
                    request?.removeAssets([asset] as NSArray)
                }, completionHandler: completion)
            }
        }

    }
    
    
    func applyPhotoFilter(_ filterName: String, input: PHContentEditingInput, output: PHContentEditingOutput, completion: () -> Void) {
        
        // Load the full size image.
        guard let inputImage = CIImage(contentsOf: input.fullSizeImageURL!)
            else { fatalError("can't load input image to edit") }
        
        // Apply the filter.
        let outputImage = inputImage
            .oriented(forExifOrientation: input.fullSizeImageOrientation)
            .applyingFilter(filterName, parameters: [:])
        
        // Write the edited image as a JPEG.
        
            if #available(iOS 10.0, *) {
                do {
                    try CIContext().writeJPEGRepresentation(of: outputImage,
                                                            to: output.renderedContentURL,
                                                            colorSpace: inputImage.colorSpace!,
                                                            options: [:])
                } catch let error {
                    fatalError("can't apply filter to image: \(error)")
                }
            } else {
                // TODO: TODO: for iOS 9
//                let context = UIGraphicsGetCurrentContext()!
//                context.
            }

        completion()
    }
    

    
    // TODO: TODO: toolbar update
    func updateToolbars() {
        
        // Enable editing buttons if the asset can be edited.
        //        editButton.isEnabled = asset.canPerform(.content) && asset.playbackStyle != .imageAnimated
//        favoriteButton.isEnabled = asset.canPerform(.properties)
//        favoriteButton.title = asset.isFavorite ? "♥︎" : "♡"
//
//        // Enable the trash button if the asset can be deleted.
//        if assetCollection != nil {
//            trashButton.isEnabled = assetCollection.canPerform(.removeContent)
//        } else {
//            trashButton.isEnabled = asset.canPerform(.delete)
//        }
//        toolbarItems = [favoriteButton, space, trashButton]
//        navigationController?.isToolbarHidden = false
    }
    
    /// can be used
//    var targetSize: CGSize {
//        let scale = UIScreen.main.scale
//        return CGSize(width: imageView.bounds.width * scale,
//                      height: imageView.bounds.height * scale)
//    }
}

extension PhotoViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageScrollView.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageScrollView.adjustFrameToCenter()
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension PhotoViewerController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Call might come on any background queue. Re-dispatch to the main queue to handle it.
        DispatchQueue.main.sync {
            // Check if there are changes to the asset we're displaying.
            guard
                let asset = asset,
                let details = changeInstance.changeDetails(for: asset)
            else {
                return
            }
            
            guard let assetAfterChanges = details.objectAfterChanges else {
                print("Photo was deleted")
                /// will be called when photo was delete from another place
                _ = self.navigationController?.popViewController(animated: true)
                return
            }

            // Get the updated asset.
            self.asset = assetAfterChanges

            // If the asset's content changed, update the image // and stop any video playback.
            if details.assetContentChanged {
                updateStillImage()
            }
        }
    }
}
