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
            assertionFailure()
            return
        }
        
        favoriteBarButton.title = asset.isFavorite ? "♥︎" : "♡"
        
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.version = .current
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
        
        /// for requestImage CIImage(image: image)?.properties is empty
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
                
                //print(CIImage(image: image)?.properties)
        })
        
        printSize()
        //printMetadata()
    }
    
    func printSize() {
        guard let asset = asset else {
            assertionFailure()
            return
        }
        
        if #available(iOS 10.0, *) {
            if let allProperties = asset.allCurrentProperties() {
                print("--- allCurrentProperties")
                print("- fileName", allProperties.fileName)
                print("- fileSize", allProperties.fileSize)
                print("- isEdited", allProperties.isEdited)
                print("- uniformTypeIdentifier", allProperties.uniformTypeIdentifier)
                print("---")
            } else {
                assertionFailure()
            }
            
            if let allProperties = asset.allOriginalProperties() {
                print("--- allOriginalProperties")
                print("- fileName", allProperties.fileName)
                print("- fileSize", allProperties.fileSize)
                print("- isEdited", allProperties.isEdited)
                print("- uniformTypeIdentifier", allProperties.uniformTypeIdentifier)
                print("---")
            } else {
                assertionFailure()
            }
            
            if let fileSize = asset.originalFileSize() {
                print("- originalFileSize:", fileSize)
            } else {
                assertionFailure()
            }
            
            if let fileSize = asset.fileSize() {
                print("- fileSize:", fileSize)
            } else {
                assertionFailure()
            }
        }
        
        print("creationDate", asset.creationDate ?? "nil")
        print("modificationDate", asset.modificationDate ?? "nil")
        
        if let creationDate = asset.creationDate, let modificationDate = asset.modificationDate {
            if abs(creationDate.timeIntervalSince1970 - modificationDate.timeIntervalSince1970) < 2 {
                print("- it is duplicate by iPhone action")
            }
        } else {
            assertionFailure()
        }
        
        if let originalFilename = asset.originalFilename() {
            title = originalFilename
        } else {
            assertionFailure()
        }
        
        if let filename = asset.filename() {
            print("- filename:", filename)
        } else {
            assertionFailure()
        }
        
        if let type = asset.uniformTypeIdentifier() {
            print("- uniformTypeIdentifier:", type)
        } else {
            assertionFailure()
        }
        
        if let isInCloud = asset.isInCloud() {
            print("- isInCloud:", isInCloud)
        } else {
            assertionFailure()
        }
        
        print(asset.location ?? "location nil")
        
        
        
        if asset.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .original
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = false
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, aVAudioMix, dict in
                
                if let avUrlAsset = avAsset as? AVURLAsset {
                    do {
                        let urlToFile = avUrlAsset.url
                        print("urlToFile", urlToFile)
                        if let size = try FileManager.default.attributesOfItem(atPath: urlToFile.path)[.size] as? NSNumber {
                            print("video size", size.int64Value)
                        }
                    } catch {
                        assertionFailure(error.localizedDescription)
                        print(error.localizedDescription)
                    }
                } else {
                    assertionFailure("iOS error")
                }

            }
            
            return
        }
        
        
        let options = PHImageRequestOptions()
        //options.deliveryMode = .fastFormat /// requestImageData ignores this option
        options.isNetworkAccessAllowed = true
        //options.isSynchronous = true
        options.resizeMode = .exact
        options.version = .current
        
        
//        let editingOptions = PHContentEditingInputRequestOptions()
//        editingOptions.isNetworkAccessAllowed = false
//        
//        asset.requestContentEditingInput(with: editingOptions) { contentEditingInput, info in
//            let url = contentEditingInput!.fullSizeImageURL
//            let orientation = contentEditingInput!.fullSizeImageOrientation
//            var inputImage = CIImage(contentsOf: url!)
//            inputImage = inputImage!.oriented(forExifOrientation: orientation)
//            
//            for (key, value) in inputImage!.properties {
//                print("key: \(key)")
//                print("value: \(value)")
//            }
//            
//            do {
//                let fileSize = try contentEditingInput?.fullSizeImageURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).fileSize
//                print("file size: \(String(describing: fileSize))")
//            } catch let error {
//                fatalError("error: \(error)")
//            }
//        }
        
        PHImageManager.default().requestImageData(for: asset, options: options) { (data, uniformTypeIdentifier, orientation, info) in
            
            /// https://developer.apple.com/documentation/photokit/phimagemanager/image_result_info_keys
            //print("- info keys", info ?? "nil")
            
            /// nil for video
            if let type = uniformTypeIdentifier {
                print("- request uniformTypeIdentifier:", type)
            } else {
                assertionFailure()
            }
            
            //let data2 = FileManager.default.contents(atPath: PHAsset.fileURL(from: info)!.path)
            
            if let data = data {
                print(data.formattedSize)
                print("- fileSize data:", data.count)
                
//                if let fileName = PHAsset.filename(from: info) {
//                    print("- iOS fileName", fileName)
//                } else {
//                    assertionFailure()
//                }
                
                let image = UIImage(data: data)
                print("- UIImage size", image?.size ?? "nil")
                
                
                /// metadata
                if let ciImage = CIImage(data: data) {
                    print(ciImage.properties)
                } else {
                    assertionFailure()
                }
            } else {
                assertionFailure()
            }
            print("--- asset pixels", asset.pixelWidth, asset.pixelHeight)
            print("-------------")
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
        guard
            let imageUrl = input.fullSizeImageURL,
            let inputImage = CIImage(contentsOf: imageUrl)
        else {
            /// will fail for videos
            fatalError("can't load input image to edit")
        }
        
        /// not exif
        /// https://stackoverflow.com/questions/39206967/attach-metadata-to-image-using-photo-framework
        
        /// https://stackoverflow.com/questions/25715280/how-to-preserve-original-photo-metadata-when-editing-phassets
        /// https://gist.github.com/kwylez/a4b6ec261e52970e1fa5dd4ccfe8898f
        /// https://stackoverflow.com/questions/26208277/metadata-exif-tiff-etc-in-photokit
//        if #available(iOS 10.0, *) {
//            inputImage.settingProperties([:])
//        } else {
//            // Fallback on earlier versions
//        }
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


import MobileCoreServices

/// Usage
/**
 if Images.isEqual(fileExtension: url.pathExtension, to: kUTTypeImage) {
    print("This is an image!")
 }
 */

func isEqual(fileExtension: String, to utType: CFString) -> Bool {
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil), UTTypeConformsTo(uti.takeRetainedValue(), utType)
    {
        return true
    } else {
        return false
    }
}
