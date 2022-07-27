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
        
    }
}
