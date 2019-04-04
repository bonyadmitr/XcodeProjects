//
//  VolumeStorageCapacity.swift
//  DiskSpace
//
//  Created by Bondar Yaroslav on 3/22/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Foundation


//    func MBFormatter(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = ByteCountFormatter.Units.useMB
//        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
//        formatter.includesUnit = false
//        return formatter.string(fromByteCount: bytes) as String
//    }
//
//    //MARK: Get String Value
//    var totalDiskSpaceInGB:String {
//        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes(), countStyle: ByteCountFormatter.CountStyle.decimal)
//    }
//
//    var freeDiskSpaceInGB:String {
//        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
//    }
//
//    var usedDiskSpaceInGB:String {
//        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
//    }
//
//    var totalDiskSpaceInMB:String {
//        return MBFormatter(totalDiskSpaceInBytes)
//    }
//
//    var freeDiskSpaceInMB:String {
//        return MBFormatter(freeDiskSpaceInBytes)
//    }
//
//    var usedDiskSpaceInMB:String {
//        return MBFormatter(usedDiskSpaceInBytes)
//    }

typealias AllVolumeStorageCapacity = (totalDiskSpace: Int64, freeDiskSpace: Int64, usedDiskSpace: Int64)

/// https://stackoverflow.com/a/47463829/5893286
/// https://developer.apple.com/documentation/foundation/urlresourcekey/checking_volume_storage_capacity
/// https://stackoverflow.com/questions/26198073/query-available-ios-disk-space-with-swift
final class VolumeStorageCapacity {
    
    static let shared = VolumeStorageCapacity()
    
    /// need only for iOS 11+
    private let homeURL: URL
    
    init() {
        let homeDir = NSHomeDirectory()
        homeURL = URL(fileURLWithPath: homeDir)
    }
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                               .volumeTotalCapacityKey])
            let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
            let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
            let usedSpaseSize = totalSpaceSize - freeSpaceSize
            
            return (totalDiskSpace: totalSpaceSize,
                    freeDiskSpace: freeSpaceSize,
                    usedDiskSpace: usedSpaseSize)
        } else {
            let homeDir = NSHomeDirectory()
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            
            let totalSpaceSize = totalSpace?.int64Value ?? 0
            let freeSpaceSize = freeSpace?.int64Value ?? 0
            
            let usedSpaseSize = totalSpaceSize - freeSpaceSize
            
            return (totalDiskSpace: totalSpaceSize,
                    freeDiskSpace: freeSpaceSize,
                    usedDiskSpace: usedSpaseSize)
        }
    }
}

enum Formatters {
    static func bytesInGB(_ bytes: Int64) -> String {
        return ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
    }
}





protocol VolumeStorageCapacityProtocol {
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity
    func totalDiskSpace() -> Int64
    func freeDiskSpace() -> Int64
    func usedDiskSpace() -> Int64
}

final class VolumeStorageCapacityAny: VolumeStorageCapacityProtocol {
    static let shared = VolumeStorageCapacityAny()
    private let volumeStorageCapacity: VolumeStorageCapacityProtocol
    
    init() {
        if #available(iOS 11.0, *) {
            volumeStorageCapacity = VolumeStorageCapacityFromiOS11()
        } else {
            volumeStorageCapacity = VolumeStorageCapacityOld()
        }
    }
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        return volumeStorageCapacity.allVolumeStorageCapacity()
    }
    
    func totalDiskSpace() -> Int64 {
        return volumeStorageCapacity.totalDiskSpace()
    }
    
    func freeDiskSpace() -> Int64 {
        return volumeStorageCapacity.freeDiskSpace()
    }
    
    func usedDiskSpace() -> Int64 {
        return volumeStorageCapacity.usedDiskSpace()
    }
}

final class VolumeStorageCapacityOld {
    
    private let homeDir = NSHomeDirectory()
    
    typealias FileSystemAttributes = [FileAttributeKey : Any]
    
    private func getSystemAttributes() -> FileSystemAttributes? {
        return try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
    }
    
    private func totalDiskSize(from systemAttributes: FileSystemAttributes?) -> Int64 {
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        return totalSpace?.int64Value ?? 0
    }
    
    private func freeDiskSize(from systemAttributes: FileSystemAttributes?) -> Int64 {
        let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
        return freeSpace?.int64Value ?? 0
    }
}
extension VolumeStorageCapacityOld: VolumeStorageCapacityProtocol {
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        let systemAttributes = getSystemAttributes()
        let totalSpaceSize = totalDiskSize(from: systemAttributes)
        let freeSpaceSize = freeDiskSize(from: systemAttributes)
        
        return (totalDiskSpace: totalSpaceSize,
                freeDiskSpace: freeSpaceSize,
                usedDiskSpace: totalSpaceSize - freeSpaceSize)
    }
    
    func totalDiskSpace() -> Int64 {
        let systemAttributes = getSystemAttributes()
        return totalDiskSize(from: systemAttributes)
    }
    
    func freeDiskSpace() -> Int64 {
        let systemAttributes = getSystemAttributes()
        return freeDiskSize(from: systemAttributes)
    }
    
    func usedDiskSpace() -> Int64 {
        let systemAttributes = getSystemAttributes()
        let totalSpaceSize = totalDiskSize(from: systemAttributes)
        let freeSpaceSize = freeDiskSize(from: systemAttributes)
        
        return totalSpaceSize - freeSpaceSize
    }
}

@available(iOS 11.0, *)
final class VolumeStorageCapacityFromiOS11 {
    
    private let homeURL = URL(fileURLWithPath: NSHomeDirectory())
    
    private func totalDiskSpace(from values: URLResourceValues?) -> Int64 {
        return Int64(values?.volumeTotalCapacity ?? 0)
    }
    private func freeDiskSpace(from values: URLResourceValues?) -> Int64 {
        return values?.volumeAvailableCapacityForImportantUsage ?? 0
    }
}

@available(iOS 11.0, *)
extension VolumeStorageCapacityFromiOS11: VolumeStorageCapacityProtocol {
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                           .volumeTotalCapacityKey])
        let totalSpaceSize = totalDiskSpace(from: values)
        let freeSpaceSize = freeDiskSpace(from: values)
        
        return (totalDiskSpace: totalSpaceSize,
                freeDiskSpace: freeSpaceSize,
                usedDiskSpace: totalSpaceSize - freeSpaceSize)
    }
    
    func totalDiskSpace() -> Int64 {
        let values = try? homeURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
        return totalDiskSpace(from: values)
    }
    
    /// like system one
    func freeDiskSpace() -> Int64 {
        let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        return freeDiskSpace(from: values)
    }
    
    func usedDiskSpace() -> Int64 {
        let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                           .volumeTotalCapacityKey])
        let totalSpaceSize = totalDiskSpace(from: values)
        let freeSpaceSize = freeDiskSpace(from: values)
        
        return totalSpaceSize - freeSpaceSize
    }
}












final class VolumeStorageCapacityInOne: VolumeStorageCapacityProtocol {
    
    /// need only for iOS <= 10
    private let homeDir: String
    
    /// need only for iOS 11
    private let homeURL: URL
    
    init() {
        homeDir = NSHomeDirectory()
        homeURL = URL(fileURLWithPath: homeDir)
    }
    
    func totalDiskSpace() -> Int64 {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            return Int64(values?.volumeTotalCapacity ?? 0)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            return totalSpace?.int64Value ?? 0
        }
    }
    
    /// like system one
    func freeDiskSpace() -> Int64 {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            return Int64(values?.volumeAvailableCapacityForImportantUsage ?? 0)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            return freeSpace?.int64Value ?? 0
        }
    }
    
    /// optmized version. not totalDiskSpace() - freeDiskSpace()
    func usedDiskSpace() -> Int64 {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                               .volumeTotalCapacityKey])
            let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
            let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
            return totalSpaceSize - freeSpaceSize
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            
            let freeSpaceSize = freeSpace?.int64Value ?? 0
            let totalSpaceSize = totalSpace?.int64Value ?? 0
            
            return totalSpaceSize - freeSpaceSize
        }
    }
    
    func allVolumeStorageCapacity() -> AllVolumeStorageCapacity {
        if #available(iOS 11.0, *) {
            let values = try? homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                               .volumeTotalCapacityKey])
            let totalSpaceSize = Int64(values?.volumeTotalCapacity ?? 0)
            let freeSpaceSize = values?.volumeAvailableCapacityForImportantUsage ?? 0
            let usedSpaseSize = totalSpaceSize - freeSpaceSize
            
            return (totalDiskSpace: totalSpaceSize,
                    freeDiskSpace: freeSpaceSize,
                    usedDiskSpace: usedSpaseSize)
        } else {
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: homeDir)
            
            let totalSpace = systemAttributes?[.systemSize] as? NSNumber
            let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
            
            let totalSpaceSize = totalSpace?.int64Value ?? 0
            let freeSpaceSize = freeSpace?.int64Value ?? 0
            
            let usedSpaseSize = totalSpaceSize - freeSpaceSize
            
            return (totalDiskSpace: totalSpaceSize,
                    freeDiskSpace: freeSpaceSize,
                    usedDiskSpace: usedSpaseSize)
        }
    }
}


import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    var urlString = ""
    
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        let scriptSource = "document.body.style.webkitTextSizeAdjust = 'auto';"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = contentController
        if #available(iOS 10.0, *) {
            webConfig.dataDetectorTypes = [.phoneNumber, .link]
        }
        
        let webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.lightGray
        
        /// there is a bug for iOS 9
        /// https://stackoverflow.com/a/32843700/5893286
        webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        return webView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = view.bounds
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return activityIndicator
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(urlString: String, title: String?) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    private func setup() {
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        webView.load(URLRequest(url: url))
        startActivity()
    }
    
    deinit {
        webView.navigationDelegate = nil
        webView.stopLoading()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func startActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    }
    
    private func stopActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
}

// MARK: - UIViewControllerRestoration
extension WebViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
        return WebViewController(coder: coder)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        switch navigationAction.navigationType {
        case .linkActivated:
            //UIApplication.shared.openSafely(navigationAction.request.url)
            //UIApplication.shared.openURL(url)
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopActivity()
    }
}
