//
//  PreviewController.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 8/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import QuickLook

final class PreviewController: QLPreviewController {
    
    private let group = DispatchGroup()
    
    func setup(with items: [QLPreviewItem]) {
        self.items.append(contentsOf: items)
        reloadData()
    }
    
    func setup(withRemotes items: [RemotePreviewItem]) {
        
        for item in items {
            group.enter()
            //        activityIndicator.stopAnimating()
            downloadfile(at: item.url) { result in
                switch result {
                case .success(let readyUrl):
                    item.previewItemURL = readyUrl
                    self.items.append(item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) { 
            self.reloadData()
        }
    }
    
//    convenience init() {
//        self.init(nibName: nil, bundle: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        //        delegate = self
        

        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        let activityIndicator = UIView()
//        activityIndicator.frame = view.bounds
//        activityIndicator.backgroundColor = .red
//        //        activityIndicator.center = view.center
//        //        activityIndicator.hidesWhenStopped = true
//        //        activityIndicator.startAnimating()
//        view.addSubview(activityIndicator)
    }

    
    private var items = [QLPreviewItem]()
    
    private func downloadfile(at fileUrl: URL, completion: @escaping UrlResult){
        
        // then lets create your document folder url
        guard let documentsDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            completion(.failure(unknownError))
            return
        }
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent)
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            completion(.success(destinationUrl))
            
            // if the file doesn't exist
        } else {
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: fileUrl) { location, response, error -> Void in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let tempLocation = location else {
                    let fileError = NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError, userInfo: [:])
                    completion(.failure(fileError))
                    return
                }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    completion(.success(destinationUrl))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
}

extension PreviewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        //return readyUrls[index] as QLPreviewItem
        return PreviewItem()// items[index]
    }
}

extension PreviewController: QLPreviewControllerDelegate {
    
}


// MARK: - PreviewItem

class PreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
}

final class LocalPreviewItem: PreviewItem {
    init(url: URL, title: String? = nil) {
        super.init()
        self.previewItemURL = url
        self.previewItemTitle = title
    }
}

final class RemotePreviewItem: PreviewItem {
    let url: URL
    
    init(url: URL, title: String? = nil) {
        self.url = url
        super.init()
        self.previewItemTitle = title
    }
}
