//
//  FileManager+Extension.swift
//  FileManagerReview
//
//  Created by Yaroslav Bondar on 14.11.2021.
//

import Foundation

/// apple source by SymbolExtractor https://github.com/Polidea/SiriusObfuscator-SymbolExtractorAndRenamer/tree/master/swift-corelibs-foundation/Foundation
///

/// `A World Without (NS)FileManager` good article name with working with POSIX api https://appnroll.com/blog/a-world-without-nsfilemanager/
/// apple source by SymbolExtractor https://github.com/Polidea/SiriusObfuscator-SymbolExtractorAndRenamer/blob/master/swift-corelibs-foundation/Foundation/FileManager.swift
/// source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager.swift
/// source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager+POSIX.swift
extension FileManager {
    
    // MARK: - directories
    
    enum Directory {
        
        /// is not created by default
        /// hidden in `file provider`
        /// `/Library/Application Support/`
        static let applicationSupport = directory(for: .applicationSupportDirectory)
        
        /// `/Library/Caches/`
        static let caches = directory(for: .cachesDirectory)
        
        /// `/Library/`
        static let library = directory(for: .libraryDirectory)
        
        /// visible in `file provider`
        /// `/Documents/`
        static let documents = directory(for: .documentDirectory)
        
        /// `/`
        static let app = appDir()
        
        /// `/tmp/`
        static let temp = tempDir()
        
        /// `/PROJECT_NAME.app/`
        static let bundle = Bundle.main.resourceURL!
        
        
        
        static func directory(for directory: FileManager.SearchPathDirectory) -> URL {
#if os(iOS) && !targetEnvironment(macCatalyst)
            assert(
                directory == .applicationSupportDirectory
                || directory == .cachesDirectory
                || directory == .libraryDirectory
                || directory == .documentDirectory
                , "\(directory.rawValue) is not available in iOS")
#endif
            
            /// 1 doc: preferred format
            /// source https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/FileManager.swift#L146
            /// needs `create: true` for `.applicationSupportDirectory`, it is not created by default.
            do {
                return try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: true)
            } catch {
                assertionFailure(error.debugDescription)
                return directoryManually(for: directory)
            }
            
            // TODO: check Directory.applicationSupport to create file in it after app deleted
            /// 2 doc: preferred format
            //let url = FileManager.default.urls(for: directory, in: .userDomainMask).first ?? directoryManually(for: directory)
            //FileManager.default.createFoldersIfNeed(for: url)
            //return url
            
            // TODO: check Directory.applicationSupport to create file in it after app deleted
            /// 3
            //let url: URL
            //if let dirPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first {
            //    url = URL(fileURLWithPath: dirPath, isDirectory: true)
            //} else {
            //    url = directoryManually(for: directory)
            //}
            //FileManager.default.createFoldersIfNeed(for: url)
            //return url
        }
        
        /// created just to guard system method fail
        private static func directoryManually(for directory: FileManager.SearchPathDirectory) -> URL {
            let dirName: String
            
            if directory == .applicationSupportDirectory {
                dirName = "Library/Application Support" //"Library/Application%20Support"
            } else if directory == .cachesDirectory {
                dirName = "Library/Caches"
            } else if directory == .libraryDirectory {
                dirName = "Library"
            } else if directory == .documentDirectory {
                dirName = "Documents"
            } else {
                assertionFailure("used not supported dir: \(directory.rawValue)")
                dirName = String(directory.rawValue)
            }
            
            return Directory.app.appendingPathComponent(dirName, isDirectory: true)
        }
    }
}
