//
//  ScreenManager.swift
//  QRScreenScanner
//
//  Created by Bondar Yaroslav on 8/3/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Foundation


/**
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
 
 all windows screenshots. from apple. (project needs update to run)
 https://developer.apple.com/library/archive/samplecode/SonOfGrab/Introduction/Intro.html
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
    
    //    static func postError(_ error : CGError) {
    //        assert(error == .success, "failed: \(error)")
    ////        if error != .success {
    ////            print("failed: \(error)")
    ////        }
    //    }
    
    /// designed for hardware mirroring with > 1 display
    /// should be no penalty for running with only 1 display, using either hardware or software mirroring drivers
    /// but not tested
    /// https://stackoverflow.com/a/41585973/5893286
    static func disableHardwareMirroring() {
        configureDisplay { displayConfig in
            // only interested in the main display
            // kCGNullDirectDisplay parameter disables hardware mirroring
            CGConfigureDisplayMirrorOfDisplay(displayConfig, CGMainDisplayID(), kCGNullDirectDisplay).handleError()
        }
    }
    
    // determine if mirroring is active (only relevant for software mirroring)
    // hack to convert from boolean_t (aka UInt32) to swift's bool
    static func isDisplayedMirrored() -> Bool {
        return CGDisplayIsInMirrorSet(CGMainDisplayID()) > 0
    }
    
    /// https://stackoverflow.com/a/41585973/5893286
    static func toggleMirroring() {
        let displayCount = displayCount2()
        
        if displayCount == 1 {
            // either it's hardware mirroring or who cares?
            disableHardwareMirroring()
            return
        }
        
        let mainDisplayId = CGMainDisplayID()
        
        // set master based on current mirroring state
        // if mirroring, master = null, if not, master = main display
        let masterDisplayId = isDisplayedMirrored() ? kCGNullDirectDisplay : mainDisplayId
        
        configureDisplay { displayConfig in
            displayIds2(for: displayCount)
                .filter { $0 != mainDisplayId }
                .forEach { CGConfigureDisplayMirrorOfDisplay(displayConfig, $0, masterDisplayId).handleError() }
        }
    }
    
    static func configureDisplay(handler: (_ displayConfig: CGDisplayConfigRef?) -> Void) {
        //let config = UnsafeMutablePointer<CGDisplayConfigRef?>.allocate(capacity: 1)
        //config.pointee
        var displayConfig: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&displayConfig).handleError()
        assert(displayConfig != nil)
        handler(displayConfig)
        
        // The first entry in the list of active displays is the main display. In case of mirroring, the first entry is the largest drawable display or, if all are the same size, the display with the greatest pixel depth.
        // The "Permanently" option might not survive reboot when run from playground, but does when run in an application
        // may not be permanent between boots using Playgroud, but is in an application
        if CGCompleteDisplayConfiguration(displayConfig, .permanently).require() != .success {
            CGCancelDisplayConfiguration(displayConfig)
        }
    }
    
    @discardableResult
    static func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
        /// or #1
        //let bitmapRep = NSBitmapImageRep(cgImage: image)
        //guard let jpegData = bitmapRep.representation(using: .png, properties: [:]) else {
        //    assertionFailure()
        //    return false
        //}
        //do {
        //    try jpegData.write(to: destinationURL, options: .atomic)
        //    return true
        //} catch {
        //    assertionFailure(error.localizedDescription)
        //    return false
        //}
        
        /// or #2
        /// https://stackoverflow.com/a/40371604/5893286
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else {
            assertionFailure(destinationURL.absoluteString)
            return false
        }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }
}

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
