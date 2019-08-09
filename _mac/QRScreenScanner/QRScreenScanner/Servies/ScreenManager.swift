//
//  ScreenManager.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 8/3/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Foundation

// TODO: get display info. DisplayUtil + DisplayInfo
// https://github.com/th507/screen-resolution-switcher/blob/master/scres.swift

// TODO: get pixel
// https://gist.github.com/antimatter15/dc809b81abea21a69f2798ff5d24ca4f

// TODO: test HardwareMirroring

/**
 
 apple example. all windows screenshots. (project needs update to run)
 https://developer.apple.com/library/archive/samplecode/SonOfGrab/Introduction/Intro.html
 
 apple doc
 https://developer.apple.com/documentation/coregraphics/quartz_window_services
 
 HardwareMirroring
 https://stackoverflow.com/a/41585973/5893286
 
 RogueMacApp
 https://github.com/MalwareSec/RogueMacApp + all connected monitors
 http://distributeddigital.io/RogueApp.html
 
 problem wth fast user switch
 https://stackoverflow.com/questions/31475656/issues-with-screen-capture-on-os-x-cgdisplaycreateimage
 
 isRunningScreensaver
 https://github.com/nst/ScreenTime/blob/master/ScreenTime/ScreenShooter.swift
 
 all connected monitors
 https://stackoverflow.com/questions/39691106/programmatically-screenshot-swift-3-macos
 
 Screenshot + screen video + example
 https://github.com/nirix/swift-screencapture
 
 working with CGWindow
 //https://stackoverflow.com/a/48030215/5893286
 */
final class ScreenManager {
    
    static let shared = ScreenManager()
    
    enum CGResult<T> {
        case success(T)
        case failure(CGError)
    }
    
    static func mainScreenImage() -> CGImage? {
        return CGDisplayCreateImage(CGMainDisplayID())
    }
    
    static func displayCount() -> CGResult<UInt32> {
        var displayCount: UInt32 = 0
        let getDisplayListResult = CGGetActiveDisplayList(0, nil, &displayCount)
        
        guard getDisplayListResult == .success else {
            assertionFailure("CGGetActiveDisplayList failed: \(getDisplayListResult)")
            return .failure(getDisplayListResult)
        }
        return .success(displayCount)
    }
    
    static func displayCount2() -> UInt32 {
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount).handleError()
        return displayCount
    }
    
    static func displayIds(for displayCount: UInt32) -> CGResult<[CGDirectDisplayID]> {
        /// https://stackoverflow.com/a/41585973/5893286
        let allocatedDisplayCount = Int(displayCount)
        var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        let getDisplayListResult = CGGetActiveDisplayList(displayCount, &displaysIds, nil)
        
        guard getDisplayListResult == .success  else {
            assertionFailure("CGGetActiveDisplayList 2 failed: \(getDisplayListResult)")
            return .failure(getDisplayListResult)
        }
        
        return .success(displaysIds)
    }
    
    static func displayIds2(for displayCount: UInt32) -> [CGDirectDisplayID] {
        /// https://stackoverflow.com/a/41585973/5893286
        let allocatedDisplayCount = Int(displayCount)
        var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        CGGetActiveDisplayList(displayCount, &displaysIds, nil).handleError()
        return displaysIds
    }
    
    /// reed doc of CGGetActiveDisplayList
    static func allDisplayImages() -> [CGImage] {
        switch displayCount() {
        case .success(let displayCount):
            
            switch displayIds(for: displayCount) {
            case .success(let displayIds):
                return displayIds.compactMap { CGDisplayCreateImage($0) }
            case .failure(let error):
                assertionFailure("CGGetActiveDisplayList failed: \(error)")
                return []
            }
            
        case .failure(let error):
            assertionFailure("CGGetActiveDisplayList failed: \(error)")
            return []
        }
    }
    
    /// reed doc of CGGetActiveDisplayList
    static func allDisplayImages2() -> [CGImage] {
        
        var displayCount: UInt32 = 0
        var getDisplayListResult = CGGetActiveDisplayList(0, nil, &displayCount)
        
        guard getDisplayListResult == .success  else {
            assertionFailure("CGGetActiveDisplayList failed: \(getDisplayListResult)")
            return []
        }
        
        let allocatedDisplayCount = Int(displayCount)
        
        /// or #1
        /// https://stackoverflow.com/a/41585973/5893286
        //var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        //getDisplayListResult = CGGetActiveDisplayList(displayCount, &displaysIds, &displayCount)
        //
        //guard getDisplayListResult == .success  else {
        //    assertionFailure("CGGetActiveDisplayList 2 failed: \(getDisplayListResult)")
        //    return []
        //}
        //
        //return displaysIds.compactMap { CGDisplayCreateImage($0) }
        
        /// or #2
        let displaysIds = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocatedDisplayCount)
        getDisplayListResult = CGGetActiveDisplayList(displayCount, displaysIds, &displayCount)
        
        guard getDisplayListResult == .success  else {
            assertionFailure("CGGetActiveDisplayList 2 failed: \(getDisplayListResult)")
            return []
        }
        
        return (0..<allocatedDisplayCount).compactMap { CGDisplayCreateImage(displaysIds[$0]) }
    }
}

//@discardableResult
//func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
//    /// or #1
//    //let bitmapRep = NSBitmapImageRep(cgImage: image)
//    //guard let jpegData = bitmapRep.representation(using: .png, properties: [:]) else {
//    //    assertionFailure()
//    //    return false
//    //}
//    //do {
//    //    try jpegData.write(to: destinationURL, options: .atomic)
//    //    return true
//    //} catch {
//    //    assertionFailure(error.localizedDescription)
//    //    return false
//    //}
//
//    /// or #2
//    /// https://stackoverflow.com/a/40371604/5893286
//    guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else {
//        assertionFailure(destinationURL.absoluteString)
//        return false
//    }
//    CGImageDestinationAddImage(destination, image, nil)
//    return CGImageDestinationFinalize(destination)
//}

//import Cocoa
//extension NSImage {
//
//    /// https://stackoverflow.com/a/44010348/5893286
//    func bitmapImageRepresentation(colorSpaceName: String) -> NSBitmapImageRep? {
//        let width = self.size.width
//        let height = self.size.height
//
//        if width < 1 || height < 1 {
//            return nil
//        }
//
//        if let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(width), pixelsHigh: Int(height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName(rawValue: colorSpaceName), bytesPerRow: Int(width) * 4, bitsPerPixel: 32)
//        {
//            let ctx = NSGraphicsContext.init(bitmapImageRep: rep)
//            NSGraphicsContext.saveGraphicsState()
//            NSGraphicsContext.current = ctx
//            self.draw(at: NSZeroPoint, from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
//            ctx?.flushGraphics()
//            NSGraphicsContext.restoreGraphicsState()
//            return rep
//        }
//        return nil
//    }
//}

extension CGError {
    
    @discardableResult
    func require() -> CGError {
        assert(self == .success, "reason: \(self)")
        return self
    }
    
    func handleError() {
        assert(self == .success, "reason: \(self)")
    }
}
