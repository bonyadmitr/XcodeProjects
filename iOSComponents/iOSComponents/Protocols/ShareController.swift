//
//  ShareController.swift
//  LifeboxShared
//
//  Created by Bondar Yaroslav on 3/13/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit
import MobileCoreServices


/// check
/// in UIViewController
/// https://github.com/CocoaHeadsBY/cher/blob/master/CherExtention/ShareViewController.swift
//override func beginRequest(with context: NSExtensionContext) {
//    super.beginRequest(with: context)
//    let kImageType : NSString = kUTTypeImage as NSString;
//
//    for inputItem: NSExtensionItem in context.inputItems as [NSExtensionItem] {
//        for itemProvider: NSItemProvider in inputItem.attachments! as [NSItemProvider] {
//            if itemProvider.hasItemConformingToTypeIdentifier(kImageType) {
//                itemProvider.loadItemForTypeIdentifier(kImageType, options: nil) { (image, error) in
//                    self.uploader.uploadFile(image as NSURL, completionHandler: { (result) -> () in
//                        self.finish(Result.createResult(image, error).map { $0 as NSURL })
//                    })
//                }
//            }
//        }
//    }
//}

protocol ShareController: class {
    func getSharedItems(handler: @escaping ([ShareData]) -> Void)
}
extension ShareController where Self: UIViewController {
    func getSharedItems(handler: @escaping ([ShareData]) -> Void) {
        
        guard
            let inputItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let attachments = inputItem.attachments as? [NSItemProvider]
        else {
            return
        }
        
        /// type constatnts
        let imageType = kUTTypeImage as String
        let pdfType = kUTTypePDF as String
        let dataType = kUTTypeData as String
        let videoTypes = [kUTTypeMovie,
                          kUTTypeVideo,
                          kUTTypeMPEG,
                          kUTTypeMPEG4,
                          kUTTypeAVIMovie,
                          kUTTypeQuickTimeMovie] as [String]
        
        var shareItems: [ShareData] = []
        let group = DispatchGroup()
        
        attachmentsFor: for itemProvider in attachments {
            
            /// IMAGE
            if itemProvider.hasItemConformingToTypeIdentifier(imageType) {
                
                group.enter()
                itemProvider.loadItem(forTypeIdentifier: imageType, options: nil) { (item, error) in
                    guard let path = item as? URL else {
                        group.leave()
                        return
                    }
                    shareItems.append(ShareImage(url: path))
                    group.leave()
                }
                
                /// DATA 1
            } else if itemProvider.hasItemConformingToTypeIdentifier(pdfType) {
                
                group.enter()
                itemProvider.loadItem(forTypeIdentifier: pdfType, options: nil) { (item, error) in
                    guard let path = item as? URL else {
                        group.leave()
                        return
                    }
                    shareItems.append(ShareData(url: path))
                    group.leave()
                }
                
            } else {
                
                /// VIDEO
                for type in videoTypes {
                    if itemProvider.hasItemConformingToTypeIdentifier(type) {
                        
                        group.enter()
                        itemProvider.loadItem(forTypeIdentifier: type, options: nil) { (item, error) in
                            guard let path = item as? URL else {
                                group.leave()
                                return
                            }
                            shareItems.append(ShareVideo(url: path))
                            group.leave()
                        }
                        
                        /// we found video type. parse next itemProvider
                        continue attachmentsFor
                    }
                }
                
                /// if not any type try to take data
                /// DATA 2
                if itemProvider.hasItemConformingToTypeIdentifier(dataType) {
                    
                    group.enter()
                    itemProvider.loadItem(forTypeIdentifier: dataType, options: nil) { (item, error) in
                        guard let path = item as? URL else {
                            group.leave()
                            return
                        }
                        shareItems.append(ShareData(url: path))
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            handler(shareItems)
        }
    }
}
