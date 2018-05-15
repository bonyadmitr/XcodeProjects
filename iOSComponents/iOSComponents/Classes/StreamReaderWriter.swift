//
//  StreamReaderWriter.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 5/15/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// https://gist.github.com/mingsai/dddce65c98753ace216c
final class StreamReaderWriter {
    
    static let copyVideoBufferSize = 4096 /// can be 1024 * 1024 = 1 mb
    static let fourGigabytes: UInt64 = 4 * 1024 * 1024 * 1024
    
    typealias ProgressCallBack = (_ copySize: Double, _ percent: Double) -> Void
    
    func copyFile(from fromURL: URL, to toURL: URL, progress: ProgressCallBack? = nil, completion: @escaping VoidResult) {
        guard let copyOutput = OutputStream(url: toURL, append: false),
            let fileInput = InputStream(url: fromURL) else {
//                completion(ResponseResult.failure(CustomErrors.unknown))
                return
        }
        
        let freeSpace = Device.freeDiskSpace
        
        let fileSize: Int
        do {
            fileSize = try sizeOfInputFile(src: fromURL)
        } catch {
            return completion(ResponseResult.failure(error))
        }
        
        guard fileSize < StreamReaderWriter.fourGigabytes else {
//            completion(ResponseResult.failure(CustomErrors.text(TextConstants.syncFourGbVideo)))
            return
        }
        
        guard fileSize < freeSpace else {
//            completion(ResponseResult.failure(CustomErrors.text(TextConstants.syncNotEnoughMemory)))
            return
        }
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: StreamReaderWriter.copyVideoBufferSize)
        var bytesToWrite = 0
        var bytesWritten = 0
        var counter = 0
        var copySize = 0
        
        fileInput.open()
        copyOutput.open()
        
        while fileInput.hasBytesAvailable {
            repeat {
                bytesToWrite = fileInput.read(buffer, maxLength: StreamReaderWriter.copyVideoBufferSize)
                bytesWritten = copyOutput.write(buffer, maxLength: StreamReaderWriter.copyVideoBufferSize)
                
                if bytesToWrite < 0 {
                    print(fileInput.streamStatus.rawValue)
                }
                if bytesWritten == -1 {
                    print(copyOutput.streamStatus.rawValue)
                }
                //move read pointer to next section
                bytesToWrite -= bytesWritten
                copySize += bytesWritten
                
                if bytesToWrite > 0 {
                    //move block of memory
                    memmove(buffer, buffer + bytesWritten, bytesToWrite)
                }
                
            } while bytesToWrite > 0
            
            counter += 1
            if counter % 10 == 0 {
                let percent = Double(copySize * 100/fileSize)
                progress?(Double(copySize), percent)
            }
        }
        
        completion(ResponseResult.success(()))
        
        //close streams
        if fileInput.streamStatus == .atEnd {
            fileInput.close()
        }
        if copyOutput.streamStatus != .writing && copyOutput.streamStatus != .error {
            copyOutput.close()
        }
    }
    
    private func sizeOfInputFile(src: URL) throws -> Int {
        let fileSize = try FileManager.default.attributesOfItem(atPath: src.path)
        return fileSize[.size] as? Int ?? 0
    }
}
