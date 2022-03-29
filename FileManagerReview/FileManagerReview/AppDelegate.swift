//
//  AppDelegate.swift
//  FileManagerReview
//
//  Created by Yaroslav Bondar on 08.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// TODO: app with 1 feature: FileManager.default.removeItemWithoutPermissions(at: folderUrl)
// TODO: app with PosixPermissions set


/** apple source
 
 Foundation
 latest with linux https://github.com/apple/swift-corelibs-foundation/tree/main/Sources/Foundation
 swift3, apple only https://github.com/apple/swift-corelibs-foundation/blob/swift-3/Foundation
 SiriusObfuscator - apple source code by SymbolExtractor https://github.com/Polidea/SiriusObfuscator-SymbolExtractorAndRenamer/tree/master/swift-corelibs-foundation/Foundation
 

 
 
 
 FileManager
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager+POSIX.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestFileManager.swift
 
 Data
 new / fread / readChunk https://github.com/weichsel/ZIPFoundation/blob/development/Sources/ZIPFoundation/Data%2BSerialization.swift
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/Data.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSData.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestNSData.swift
 
 
 URL
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/URL.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestURL.swift
 NSURL
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestNSURL.swift
 
 
 deletingLastPathComponent source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSPathUtilities.swift#L241
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/URL.swift#L810
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L874
 https://github.com/apple/swift-corelibs-foundation/blob/main/CoreFoundation/URL.subproj/CFURL.c#L4916
 https://github.com/opensource-apple/CF/blob/master/CFURL.c#L4532
 
 resourceValues(forKeys
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L594
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L663
 storage init https://github.com/apple/swift-corelibs-foundation/blob/main/CoreFoundation/URL.subproj/CFURL.c#L5320
 
 
 
 URLCache
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/FoundationNetworking/URLCache.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestURLCache.swift
 
 
 NSCache
 apple source
 https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSCache.swift
 https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestNSCache.swift
 
 */




/**
 TODO
 
 check https://github.com/GianniCarlo/DirectoryWatcher
 check https://github.com/vmanot/Filesystem
 check PosixPermissions vs FilePermission https://github.com/vmanot/Filesystem/blob/master/Sources/Intramodular/Access%20Control/FilePermission.swift
 
 
 //String(contentsOf: URL)
 //String(contentsOfFile: String)
 
 //        NSDictionary(contentsOf: URL)
 //        NSDictionary(contentsOf: URL, error: () )
 //        NSDictionary(contentsOfFile: String)
 //        let dict = NSDictionary() as? Dictionary<String, AnyObject>
 //        PropertyListSerialization
 
 //        Data(contentsOf: URL)
 
 //        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
 //            let nsDictionary = NSDictionary(contentsOfFile: path)
 //        }
 //        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist") {
 //            let nsDictionary = NSDictionary(contentsOf: url)
 //        }
 
 //        Bundle.main.infoDictionary
 
 
 func check free disk space before write file
 
 clear cache by remove folder https://stackoverflow.com/a/14910128/5893286
 
 
 GCD in fileSystem?
 multythread fast read several big files
 
 DispatchSource for files
 FileMonitor - DispatchSource: Detecting changes in files and folders in Swift https://swiftrocks.com/dispatchsource-detecting-changes-in-files-and-folders-in-swift
 FolderMonitor - Detecting changes to a folder https://medium.com/over-engineering/monitoring-a-folder-for-changes-in-ios-dc3f8614f902
 
 ---------------------------- Thread Safe access
 
 files
 posix functions
 
 FileManager
 /// doc: The methods of the shared FileManager object can be called from multiple threads safely https://developer.apple.com/documentation/foundation/filemanager
 /// but for delegates - create a unique instance
 most(or all) functions execute sync

 ---------------------------- NSData cache
 /// Disable file system caching for files being read once `Data(contentsOf: URL, options: .uncached)` https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/PerformanceTips/PerformanceTips.html
 /// doc: file should not be stored in the file-system caches
 //        try! Data(contentsOf: URL(string: "")!, options: .uncached)
 
 NSData cache for fileSystem file
 
 NSData cache for remote file (seems like NSURLConnection used or URLSession)
 apple source https://github.com/Polidea/SiriusObfuscator/blob/master/SymbolExtractorAndRenamer/swift-corelibs-foundation/Foundation/NSData.swift#L168 +
 apple source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSData.swift#L217
 
 ---
 
 
 
 /// doc: file should not be stored in the file-system caches
 try! Data(contentsOf: URL(string: "")!, options: .uncached)
 
 https://habr.com/ru/post/591775/#comment_23776127
 Буфер NSData хранится на диске, а не в оперативной памяти. Это очень легко проверить, открыв какой-нить фильмец на пару гигабайт размером через NSData
 
 
 nscache
 
 urlCache
 
 NSPurgeableData https://developer.apple.com/documentation/foundation/nspurgeabledata
 https://github.com/search?l=Swift&q=purgeable&type=Code
 
 
 URLSession.shared.dataTask(with: url) cache
 downloadTask cache
 https://habr.com/ru/post/591775/#comment_23776247
 https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
 
 
 memory for Low-Memory Warnings https://developer.apple.com/documentation/xcode/responding-to-low-memory-warnings
 `UIApplication.shared.perform(Selector(("_performMemoryWarning")))` https://stackoverflow.com/a/48202910/5893286
 
 ------ UIImage cache
 
 UIImage cache (there is no for CGImage)
 
 https://habr.com/ru/post/591775/#comment_23776127
 UIImage. Так он (как и Image в Свифт) работает поверх NSData все с тем же механизмом. Я это четко осознал, когда бил на тайлы 100МБ jpeg военную карту Москвы на 4S. Просто прикиньте, какой размер эта карта занимает попиксельно после декодирования jpeg. И тем не менее данная карта прекрасно отображалась на экранчике мобильного телефона. Правда, плохо масштабировалась, что я позже и решал тайлингом.
 
 
 short https://stackoverflow.com/a/8644628/5893286
 /// uses memory cache - Because these methods cache the image data automatically, they are especially recommended for images that you use frequently https://developer.apple.com/documentation/uikit/uiimage
 /// doc: The system may purge cached image data at any time to free up memory. Purging occurs only for images that are in the cache but are not currently being used. https://developer.apple.com/documentation/uikit/uiimage/1624154-init
 /// doc: In iOS 9 and later, this method is thread safe
 UIImage(named: "")
 
 /// without caching - These methods load the image data from disk each time, so you should not use them to load the same image repeatedly
 /// doc: This method loads the image data into memory and marks it as purgeable. If the data is purged and needs to be reloaded, the image object loads that data again from the specified path. https://developer.apple.com/documentation/uikit/uiimage/1624112-init
 UIImage(contentsOfFile: "")
 
 extension UIImage https://stackoverflow.com/a/39551766/5893286
 todo custom cache if need https://stackoverflow.com/a/34792550/5893286
 
 
 
 todo
 check purgeable virtual memory Statistics + find other memory stats https://gist.github.com/algal/cd3b5dfc16c9d577846d96713f7fba40 + https://github.com/JosephDuffy/GatheredKit/blob/master/Source/Sources/Memory.swift
 check with memory for Low-Memory Warnings `UIApplication.shared.perform(Selector(("_performMemoryWarning")))` https://developer.apple.com/documentation/xcode/responding-to-low-memory-warnings
 init(data + Uncached https://developer.apple.com/documentation/uikit/uiimage/1624106-init
 CGImage
 CIImage
 help https://developer.apple.com/documentation/uikit/uiimage
 
 /// private api https://github.com/xybp888/iOS-Header/blob/master/13.0/PrivateFrameworks/UIKitCore.framework/UIImage.h
 //UIImage._flushSharedImageCache()
 //UIImage()._isCached
 //UIImage._clearAssetCaches
 //UIImage._flushCache()

 assets library vs in folder file(localization, cache, app store optimizations, different platforms, different trait environments, different scale factors, Different Appearances) https://developer.apple.com/documentation/uikit/uiimage
 
 
 
 
/// Clear launch screen cache
/// Make sure to call only in debug mode
func clearLaunchScreenCache() {
    do {
        try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
    } catch {
        print("Failed to delete launch screen cache: \(error)")
    }
}
 
 
 ----------- custom cache
 
 Nuke
 https://kean.blog/post/nuke-9
 https://github.com/kean/Nuke/blob/master/Tests/ImageCacheTests.swift
 https://github.com/kean/Nuke/blob/master/Tests/DataCacheTests.swift
 algorithm for NSCache is not documented
 server Cache-Control https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control
 Resumable Downloads https://kean.blog/post/nuke-9#resumable-downloads + HTTP range requests https://developer.mozilla.org/en-US/docs/Web/HTTP/Range_requests
 
 
 ----------------------------
 // MARK: - Mapping Files Into Memory / read file
 
 /// apple: When to Map Files + When Not to Map Files https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemAdvancedPT/MappingFilesIntoMemory/MappingFilesIntoMemory.html
 //mmap + munmap https://en.wikipedia.org/wiki/Mmap + https://en.wikipedia.org/wiki/Memory-mapped_file
 //swift example https://github.com/akirark/MemoryMappedFileSwift/blob/master/MemoryMappedFile/MemoryMappedFile.swift
 //MAP_FAILED https://github.com/apple/swift-corelibs-foundation/blob/swift-3/Foundation/NSData.swift#L288
 
 /// ru virtual memory - mmap + PROT_NONE + mprotect https://habr.com/ru/company/otus/blog/537568/
 mmap macOS - VirtualAlloc windows https://stackoverflow.com/a/3561988/5893286 + https://en.wikipedia.org/wiki/Mmap
 ! mmap wrapper + PROT_NONE https://github.com/ixy-languages/ixy.swift/blob/master/ixy/Sources/ixy/Memory/MemoryMap.swift
 PROT_NONE https://github.com/vmanot/POSIX/blob/master/Sources/Intermodular/Helpers/Darwin/Darwin.POSIXMemoryMapProtection.swift + https://github.com/vmanot/POSIX/blob/master/Sources/Intermodular/Helpers/Darwin/Darwin.POSIXMemoryMap.swift
 mmap demo https://github.com/J0hnngWong/mmapInSwift/blob/master/mmapDemo/ViewController.swift
 logic example https://stackoverflow.com/a/28717769/5893286
 inspired ru https://habr.com/ru/post/598781/
 //virtual_memory_guard_exception_codes
 //vm_statistics64.init
 
 // theory https://www.usenix.org/system/files/conference/hotstorage17/hotstorage17-paper-choi.pdf
 // ENOMEM https://developer.apple.com/documentation/foundation/posixerror/2292966-enomem
 //low-memory scenarios https://stackoverflow.com/q/6172919/5893286
 
 check: map file to virtual memory vs simple cache
 
 For data read randomly from a file, you can sometimes improve performance by mapping that file directly into your app’s virtual memory space. File mapping is a programming convenience for files you want to access with read-only permissions. It lets the kernel take advantage of the virtual memory paging mechanism to read the file data only when it is needed. You can also use file mapping to overwrite existing bytes in a file; however, you cannot extend the size of the file using this technique. Mapped files bypass the system disk caches, so only one copy of the file is stored in memory.
 If you map a file into memory and the file becomes inaccessible—because the disk containing the file was ejected or the network server containing the file is unmounted—your app will crash with a SIGBUS error. Your app can also crash if you map a file into memory, that file gets truncated, and you attempt to access data at a range that not longer exists
 https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/PerformanceTips/PerformanceTips.html
 
 //-------- NSData check
 
 /// https://forums.swift.org/t/what-s-the-recommended-way-to-memory-map-a-file/19113/3
 /// Safe File Mapping for NSData https://developer.apple.com/library/archive/releasenotes/Foundation/RN-Foundation-iOS/Foundation_iOS5.html
 

 
 */
