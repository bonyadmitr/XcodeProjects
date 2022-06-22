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
 

 Bundle url(forResource return url in CFBundleCopyResourceURLForLocalization https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/Bundle.swift#L299=
 
 
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







/** file read / write

 
 real file copy, nor mark if copy
 by char read or stream
 
 Reading and Writing Files Asynchronously
 NSInputStream and NSOutputStream
 apple source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/Stream.swift
 +tests https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestStream.swift
 https://stackoverflow.com/a/35392367/5893286
 Reading and Writing Files Without File Coordinators https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/TechniquesforReadingandWritingCustomFiles/TechniquesforReadingandWritingCustomFiles.html
 BinaryReader https://github.com/vmanot/Data/blob/master/Sources/Intramodular/CSV/BinaryReader.swift

 
 security
 md5
 File protection
 device is locked + Keychain + Extension https://nemecek.be/blog/104/checking-if-device-is-locked-or-sleeping-in-ios
 real delete
 Zero-Filling - delay when closing your files https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/PerformanceTips/PerformanceTips.html
 
 File Provider (files app) https://developer.apple.com/documentation/fileprovider
 ? file observing in app
 
 notes from Notes
 
 POSIX Level / open vs fopen
 fopen + fclose
 fgetln + strncpy
 optimized file read line by line
 concatFiles https://github.com/amosavian/ExtDownloader/blob/master/Utility.swift#L159
 read by char https://github.com/amosavian/ExtDownloader/blob/master/Utility.swift#L159
 
 
 
 
 
 
 done
 
 simple Working with Files in Swift https://www.techotopia.com/index.php/Working_with_Files_in_Swift_on_iOS_8
 
 FileHandle
 FileHandle is wrapper arround `fopen`
 NSFileHandle - parallels the process for reading and writing files at the POSIX level
 ?  default file observing
 concatFiles https://github.com/amosavian/ExtDownloader/blob/master/ClassExtensions.swift#L970
 apple source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileHandle.swift
 + tests https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestFileHandle.swift
 
 
 
 
 /// DispatchIO + DispatchData
 DispatchIO work at the POSIX level
 /// Copy - read + write https://github.com/empty666/DispatchCopier/blob/master/DispatchCopier/worker/DispatchCopyWorker.swift
 /// !!! Wrapper https://github.com/vitali-kurlovich/DispatchIOWrapper/blob/main/Sources/DispatchIOWrapper/DispatchIOWrapper.swift
 /// search https://github.com/search?l=Swift&q=DispatchIO&type=Repositories
 swift doc https://developer.apple.com/documentation/dispatch/dispatchio
 objc doc https://developer.apple.com/documentation/dispatch/1388933-dispatch_read
 
         let lock = DispatchWorkItem{}
        
        DispatchQueue.global().async {
            
            /// DispatchData https://developer.apple.com/documentation/dispatch/dispatchdata
            let dispatchData = data.withUnsafeBytes { DispatchData(bytes: $0) }

            let writeChannel = DispatchIO(type: .stream,
                                          path: fileUrl.path,
                                          oflag: (O_RDWR | O_CREAT | O_APPEND),
                                          mode: (S_IWUSR | S_IRGRP | S_IRUSR | S_IROTH),
                                          queue: .global()) { error in
                // Execute once Close Channel
                if error == 0 {
                    print("Complete Clean Write Channel");
                } else {
                    print("Failed to Write File. Error Code : \(error)");
                }
                lock.perform()
            }!

            writeChannel.write(offset: 0, data: dispatchData, queue: .global(), ioHandler: { [writeChannel] done, data, error in //doc: data that remains to be written
                print("- ioHandler", done, data?.count ?? "nil")
                if !done {
                    print("failed to Write File. Error Code : \(error)")
                    writeChannel.close()
                }
            })
            
        }
        
        lock.wait()
 
 
 */





/**
 TODO
 
!!! extendedAttribute = withUnsafeFileSystemRepresentation + getxattr https://github.com/DaveWoodCom/XCGLogger/blob/master/Sources/XCGLogger/Extensions/URL%2BXCGAdditions.swift#L17=
 
 
 posixError https://github.com/DaveWoodCom/XCGLogger/blob/master/Sources/XCGLogger/Extensions/URL%2BXCGAdditions.swift#L79=
     private static func posixError(_ err: Int32) -> NSError {
        return NSError(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: [NSLocalizedDescriptionKey: String(cString: strerror(err))])
    }
 
 TextOutputStream https://nshipster.com/textoutputstream/
 AXIsProcessTrustedWithOptions  https://gist.github.com/drhisham-code/6fc2a721d4e289623e10e8a490a23cd3
 
 check https://github.com/GianniCarlo/DirectoryWatcher
 check https://github.com/vmanot/Filesystem
 check PosixPermissions vs FilePermission https://github.com/vmanot/Filesystem/blob/master/Sources/Intramodular/Access%20Control/FilePermission.swift
 https://github.com/nvzqz/FileKit
 https://github.com/Augustyniak/FileExplorer
 https://github.com/saoudrizwan/Disk
 
 
 
 disk space changes notification https://stackoverflow.com/a/14604552/5893286
 only use timer, or other app triggers like enter foreground
 
 
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
 
 /// Old. only with NSData
 //NSData(contentsOfMappedFile: "")
 //NSData.dataWithContentsOfMappedFile("")
 
 /// new
 /// file should be mapped into virtual memory, if possible and safe
 try! Data(contentsOf: URL(string: "")!, options: .mappedIfSafe)
 /// map the file in if possible
 try! Data(contentsOf: URL(string: "")!, options: .alwaysMapped)
 /// apple source alwaysMapped https://github.com/Polidea/SiriusObfuscator/blob/master/SymbolExtractorAndRenamer/swift-corelibs-foundation/Foundation/NSData.swift#L388
 
 
 ---------------------------- open file
 
 guard let file = fopen(filePath, "r") else {
    assertionFailure("Could not open file at \(filePath)")
    return
 }
 --
     // Open the file.
    fileDescriptor = open( inPathName, O_RDONLY, 0 );
    if( fileDescriptor < 0 )
    {
       outError = errno;
    }
    else
    {
        // We now know the file exists. Retrieve the file size.
        if( fstat( fileDescriptor, &statInfo ) != 0 )
 ----------------------------
 

 
 // It's good habit to alloc/init the file manager for move/copy operations,
 // just in case you decide to add a delegate later.
 https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/ManagingFIlesandDirectories/ManagingFIlesandDirectories.html
 
 view file manager https://www.raywenderlich.com/666-filemanager-class-tutorial-for-macos-getting-started-with-the-file-system
 
 macOS icons
 let fileIcon = NSWorkspace.shared().icon(forFile: item.path)
 
 create documents app (project)
 
 NSDocument + NSDocumentController macOS
 https://developer.apple.com/documentation/appkit/nsdocument
 https://developer.apple.com/documentation/appkit/documents_data_and_pasteboard/developing_a_document-based_app
 
 UIDocument (Document app xcode template) UIDocumentBrowserViewController
 
 
 UISupportsDocumentBrowser - LSSupportsOpeningDocumentsInPlace https://stackoverflow.com/a/52262367/5893286
 UIDocumentPickerViewController https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/DocumentPickerProgrammingGuide/Introduction/Introduction.html
 ??? UIDocumentInteractionController
 
NSOpenPanel + NSSavePanel macOS https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/UsingtheOpenandSavePanels/UsingtheOpenandSavePanels.html
 https://developer.apple.com/documentation/appkit/nssavepanel
 

 File Promises
 https://developer.apple.com/documentation/appkit/documents_data_and_pasteboard/supporting_drag_and_drop_through_file_promises
 https://developer.apple.com/documentation/appkit/nsfilepromiseprovider
 
 drag and drop https://developer.apple.com/documentation/appkit/documents_data_and_pasteboard/supporting_drag_and_drop_through_file_promises
 
 NSPasteboard https://developer.apple.com/documentation/appkit/nspasteboard
 
 check `includesDirectoriesPostOrder: FileManager.DirectoryEnumerationOptions`

 custom ObjectStorage
 https://gist.github.com/khanlou/69309d9b0b078409a7b0445dac45c23e
 NSFileCoordinator https://gist.github.com/khanlou/d5328cf31fe681e027385d75ef335d13
 
 --------------- NSFileCoordinator + NSFilePresenter
 https://khanlou.com/2019/03/file-coordination/
 
 NSFileCoordinator is indispensable in a few cases:

Since Mac apps deal with files being edited by multiple apps at once, almost all document-based Mac apps use it. It provides the underpinning for NSDocument.
Extensions on iOS and the Mac are run in different process and may be mutating the same files at the same time.
Syncing with cloud services requires the ability to handle updates to files while they are open, as well as special dispensation for reading files for the purpose of uploading them.

 Note: if you don’t care about other processes or in-process code outside of your control (i.e. in a framework), you absolutely should NOT use file coordination as a means of mutual exclusion. The cross-process functionality is definitely the main motivation to use File Coordination, but it comes with a relatively high performance (and cognitive) cost in comparison to in-process means.
 

 
 /// needs for ShareViewController in share extension
 final class FilesExistManager {
    
    static let shared = FilesExistManager()
    
    /// need to test:
    /// can one NSFileCoordinator coordinate some urls?
    /// put NSFileCoordinator() in property
    func waitFilePreparation(at url: URL, complition: ResponseVoid) {
        do {
            _ = try NSFileCoordinator().coordinate(readingItemAt: url, options: .forUploading)
            complition(ResponseResult.success(()))
        } catch  {
            complition(ResponseResult.failed(error))
        }
    }
}
 
 // using
 FilesExistManager.shared.waitFilePreparation(at: item.url)
 
 /// NSFileCoordinator+Coordinate
 extension NSFileCoordinator {
    func coordinate(readingItemAt url: URL, options: NSFileCoordinator.ReadingOptions = []) throws -> URL {
        var fcError: NSError?
        var resultUrl: URL?
        
        coordinate(readingItemAt: url, options: .forUploading, error: &fcError) { trueUrl in
            resultUrl = trueUrl
        }
        
        if let resultUrl = resultUrl {
            return resultUrl
        } else if let error = fcError {
            throw error
        } else {
            let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])
            throw unknownError
        }
    }
}
---------------
 
 
 !!! check for new code https://github.com/weichsel/ZIPFoundation/tree/development/Sources/ZIPFoundation
 
 Localizing the Name of a Directory
 https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemAdvancedPT/Introduction/Introduction.html
 
 
 zip
 https://github.com/weichsel/ZIPFoundation/tree/development/Sources/ZIPFoundation
 
 
 uuid
 ProcessInfo.processInfo.globallyUniqueString
 UUID(),stringValue
 
 
 
 
 URL FileSystemRepresentation
 https://github.com/Polidea/SiriusObfuscator-SymbolExtractorAndRenamer/blob/master/swift-corelibs-foundation/Foundation/FileManager.swift#L641
 
 
 write(toFile atomic https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSData.swift#L461
 
 
 folder size with symlinks and hardlinks
 
 check new
 !!! https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/Introduction/Introduction.html
 
 
 check
 https://developer.apple.com/documentation/foundation/filemanager/2293212-replaceitemat
 https://developer.apple.com/documentation/foundation/filemanager/1411577-url
 https://developer.apple.com/documentation/foundation/filemanager/1413929-componentstodisplay
 https://developer.apple.com/documentation/foundation/filemanager/1415275-contentsequal
 https://developer.apple.com/documentation/foundation/filemanager/1407229-getrelationship
 https://developer.apple.com/documentation/foundation/filemanager/1412020-changecurrentdirectorypath
 https://developer.apple.com/documentation/foundation/filemanager/1414306-trashitem
 
 print( dirToEnumerate.startAccessingSecurityScopedResource() )
 dirToEnumerate.stopAccessingSecurityScopedResource()
 https://medium.com/fantageek/how-to-access-bookmark-url-in-macos-b38bc82f03e9
 
 URL relativeTo
 apple tests https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestURL.swift#L143
 
 UIDocument
 
 !!! share extension
 handle objects and files
 shared folder
 
 ! share action
 hardlinks
 share as name
 share as size (compression)
 
 compression images, files - optimization sizes
 zip
 
 ! pastboard + new api
 copy - past files
 
 undo - redo actions and gestures + UI
 
 siri open file (some photo)
 spotlight search file (some photo)
 
 secret space + gestures
 passcode
 isExcludedFromBackup
 do {
 var resourceValues = URLResourceValues()
 resourceValues.isExcludedFromBackup = true
 try url.setResourceValues(resourceValues)
 } catch {
 LoggerErrors.logError(CustomErrors.commonError(error: error))
 }
 
 qr code gen + reader
 
 text scanner (? new api)
 
 add images picker + camera
 
 pdf create
 
 file editor (with lines)
 
 html browser + colors
 
 EXIF reader and editor
 
 jailbreak file system https://medium.com/@lucideus/understanding-the-ios-file-system-eee3dc87e455 + find others
 
 import CoreFoundation posiblities and optimizations
 
 ?base64
 
 !!! autoreleasepool for datas
 
 
 file size
 disk size
 ByteCountFormatter
 https://nemecek.be/blog/22/how-to-get-file-size-using-filemanager-formatting
 
 external disks api
 gmail
 yandex
 ftp
 iCloud - FileManager.default.url(forUbiquityContainerIdentifier https://nemecek.be/blog/6/saving-files-into-users-icloud-drive-using-filemanager
 
 
 
 
 
 
 iOS file manager app
 scan documents https://nemecek.be/blog/26/how-to-scan-documents-in-under-10-lines-of-code
 QLPreviewController https://nemecek.be/blog/13/how-to-easily-display-files-like-pdf-documents-images-and-more-in-your-app
 ??? create event EKCalendarChooser https://nemecek.be/blog/16/how-to-use-ekcalendarchooser-in-swift-to-let-user-select-calendar-in-ios
 ??? or EKEventEditViewController https://nemecek.be/blog/3/how-to-use-ekeventeditviewcontroller-in-swift-to-let-user-save-event-to-ios-calendar
 ? contacts backup CNContactVCardSerialization + CNContactStore + my project ContactsManager + https://stackoverflow.com/a/38338768/5893286
 QLThumbnailGenerator for previews / thumbnails https://nemecek.be/blog/12/how-to-generate-image-previewsthumbnails-of-various-files
 string localizedCompare or localizedStandardCompare in file names sorting https://stackoverflow.com/a/15436564/5893286
 sortFilesList https://github.com/amosavian/ExtDownloader/blob/master/ClassExtensions.swift#L1074
 image converter
 
 
 
 
 
 new folder name generator `new_folder_1`
 
var stringByUniqueFileName: String {
    if (try? NSFileManager.defaultManager().attributesOfItemAtPath(self)) != nil {
        let curFileNum = self.lastPathComponent
        var unique = false
        var i = Int(curFileNum.split(" ").last ?? "noname") ?? 2
        var newName = self
        while !unique && i < 1000 {
            newName = ((self.fileURL.URLByDeletingLastPathComponent!).path! + " \(i)").fileURL.URLByAppendingPathExtension(self.pathExtension).path!;
            newName = newName.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
            unique = (try? NSFileManager.defaultManager().attributesOfItemAtPath(newName)) == nil;
            i++;
        }
        return newName
    } else {
        return self
    }
}

 
 
 
 
 UTType find
 UTTypeCreatePreferredIdentifierForTag https://github.com/amosavian/ExtDownloader/blob/master/ClassExtensions.swift#L288
 ImageFormat https://github.com/bonyadmitr/ImageFormat/blob/master/ImageFormat/ImageFormat.swift
 
 mime
 uti
var extensionInfo: (mime: String, uti: String, desc: String) {
    let attrib = try? NSFileManager.defaultManager().attributesOfItemAtPath(self)
    let isDirectory = (attrib?[NSFileType] as? String ?? "") == NSFileTypeDirectory
    let isSymLink = (attrib?[NSFileType] as? String ?? "") == NSFileTypeSymbolicLink
    if isDirectory {
        return("inode/directory", "public.directory", "Folder")
    } else if isSymLink {
        return("inode/symlink", "public.symlink", "Alias")
    } else {
        if !NSFileManager.defaultManager().fileExistsAtPath(self) {
            return ("", "", "")
        }
        let fileExt = self.pathExtension;
        let utiu = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExt, nil)?.takeUnretainedValue();
        let uti = String(utiu).hasPrefix("dyn.") ? "public.data" : String(utiu)
        let mimeu = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
        let mime = mimeu == nil ? "application/octet-stream" : mimeu?.takeUnretainedValue();
        let descu = UTTypeCopyDescription(utiu ?? "")
        let desc = (descu == nil) ? (self.pathExtension.uppercaseString + " File") : String(descu?.takeUnretainedValue());
        return (mime as? String ?? "application/octet-stream", uti, desc);
    }
}

 
 
 private func clearCache() {
    let fileManager = FileManager.default
    guard let documentsUrl =  fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
        assertionFailure()
        return
    }
    let documentsPath = documentsUrl.path
    
    do {
        let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
        print("--- all files in cache:\n\(fileNames)")
        
        for fileName in fileNames {
            /// System Error Code=513:
            /// "Snapshots" couldn’t be removed because you don’t have permission to access it.
            guard fileName != "Snapshots" else {
                return
            }
            let filePathName = "\(documentsPath)/\(fileName)"
            try fileManager.removeItem(atPath: filePathName)
        }
        
        let files = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
        print("--- all files in cache after deleting images:\n\(files)")
        
    } catch {
        assertionFailure("Could not clear temp folder: \(error)")
    }

    /// #2
    /// https://stackoverflow.com/a/50122279/5893286
//        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
//        let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
//        let path = String(format:"%@/%@/Cache.db-wal",caches, appId)
//        do {
//            try FileManager.default.removeItem(atPath: path)
//        } catch {
//            print("ERROR DESCRIPTION: \(error)")
//        }
    
}
 
 
 macOS
 SearchPathDomainMask.localDomainMask + others
 
 NSWorkspace.shared.isFilePackage(atPath
 
 
 NSFileOwnerAccountID
 NSFileGroupOwnerAccountID
 NSFilePosixPermissions
 try! FileManager.default.attributesOfItem(atPath: libUrl.path)
 
 /// Initialize with string.
 ///
 /// Returns `nil` if a `URL` cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string).
 public init?(string: String)
 
 /// Initialize with string, relative to another URL.
 ///
 /// Returns `nil` if a `URL` cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string).
 public init?(string: String, relativeTo url: URL?)
 
 /// Initializes a newly created file URL referencing the local file or directory at path, relative to a base URL.
 ///
 /// If an empty string is used for the path, then the path is assumed to be ".".
 /// - note: This function avoids an extra file system access to check if the file URL is a directory. You should use it if you know the answer already.
 @available(macOS 10.11, iOS 9.0, *)
 public init(fileURLWithPath path: String, isDirectory: Bool, relativeTo base: URL?)
 
 /// Initializes a newly created file URL referencing the local file or directory at path, relative to a base URL.
 ///
 /// If an empty string is used for the path, then the path is assumed to be ".".
 @available(macOS 10.11, iOS 9.0, *)
 public init(fileURLWithPath path: String, relativeTo base: URL?)
 
 /// Initializes a newly created file URL referencing the local file or directory at path.
 ///
 /// If an empty string is used for the path, then the path is assumed to be ".".
 /// - note: This function avoids an extra file system access to check if the file URL is a directory. You should use it if you know the answer already.
 public init(fileURLWithPath path: String, isDirectory: Bool)
 
 /// Initializes a newly created file URL referencing the local file or directory at path.
 ///
 /// If an empty string is used for the path, then the path is assumed to be ".".
 public init(fileURLWithPath path: String)
 
 /// Initializes a newly created URL using the contents of the given data, relative to a base URL.
 ///
 /// If the data representation is not a legal URL string as ASCII bytes, the URL object may not behave as expected. If the URL cannot be formed then this will return nil.
 @available(macOS 10.11, iOS 9.0, *)
 public init?(dataRepresentation: Data, relativeTo url: URL?, isAbsolute: Bool = false)
 
 /// Initializes a URL that refers to a location specified by resolving bookmark data.
 @available(swift 4.2)
 public init(resolvingBookmarkData data: Data, options: URL.BookmarkResolutionOptions = [], relativeTo url: URL? = nil, bookmarkDataIsStale: inout Bool) throws
 
 /// Creates and initializes an NSURL that refers to the location specified by resolving the alias file at url. If the url argument does not refer to an alias file as defined by the NSURLIsAliasFileKey property, the NSURL returned is the same as url argument. This method fails and returns nil if the url argument is unreachable, or if the original file or directory could not be located or is not reachable, or if the original file or directory is on a volume that could not be located or mounted. The URLBookmarkResolutionWithSecurityScope option is not supported by this method.
 @available(macOS 10.10, iOS 8.0, *)
 public init(resolvingAliasFileAt url: URL, options: URL.BookmarkResolutionOptions = []) throws
 
 /// Initializes a newly created URL referencing the local file or directory at the file system representation of the path. File system representation is a null-terminated C string with canonical UTF-8 encoding.
 public init(fileURLWithFileSystemRepresentation path: UnsafePointer<Int8>, isDirectory: Bool, relativeTo baseURL: URL?)
 
 
 
 
 
 
 
 
extension NSURL {
    var remoteSize: Int64 {
        var contentLength: Int64 = NSURLSessionTransferSizeUnknown
        let request = NSMutableURLRequest(URL: self, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0);
        request.HTTPMethod = "HEAD";
        request.setValue("", forHTTPHeaderField: "Accept-Encoding")
        request.timeoutInterval = 2;
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            contentLength = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            dispatch_group_leave(group)
        }).resume()
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)))
        return contentLength
    }
}

 https://github.com/amosavian/ExtDownloader/blob/master/ClassExtensions.swift#L342
 
 
 
 
 
 
 
 
 
 ---------------------------------------- done
 
 /// !!! `URL(fileURLWithPath path: String, isDirectory: Bool)` This function avoids an extra file system access to check if the file URL is a directory. You should use it if you know the answer already.
 /// source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSURL.swift#L231

 
 
 Performance Tips https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/PerformanceTips/PerformanceTips.html
 1. Minimize the number of file operations - less read from disk and network
 2. reuse URLs - NSURL objects can be expensive to construct +  resourceValuesForKeys(_:) cache
 3. use big chunks of Data - how fast data is read from disk to a local buffer (TODO example)
 4. sequential reads much faster
 5. Defer read from disk
 6. Recomputing simple values is significantly faster than reading the same value from disk.
 7. Caching files in memory increases memory usage + system may cache some file data for you automatically
 
 */
