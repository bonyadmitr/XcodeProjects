//
//  ViewController.swift
//  ScreenRecorder
//
//  Created by Bondar Yaroslav on 8/14/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import AVKit.AVPlayerView


let videoDestination: URL = {
    let tempDir = NSTemporaryDirectory()
    let videoPath = "\(tempDir)screenRecording2.mp4"
    return URL(fileURLWithPath: videoPath)
}()

class ViewController: NSViewController {

    @IBOutlet private weak var playerView: AVPlayerView!
    @IBOutlet private weak var startRecordingButton: NSButton!
    @IBOutlet private weak var stopRecordingButton: NSButton!
    @IBOutlet private weak var playRecordingButton: NSButton!

    
    private lazy var screenRecorder = ScreenRecorder(destination: videoDestination)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FileManager.default.fileExists(atPath: videoDestination.path) {
            try? FileManager.default.removeItem(atPath: videoDestination.path)
        }
        
        stopRecordingButton.isEnabled = false
        playRecordingButton.isEnabled = false
        
        print(AVCaptureDevice.devices(for: .muxed))
        Devices.enableDalDevices()
        print(AVCaptureDevice.devices(for: .muxed))
        NotificationCenter.default.addObserver(forName: .AVCaptureDeviceWasConnected, object: nil, queue: nil) { notification in
            print(AVCaptureDevice.devices(for: .muxed))
            print(notification)
            print()
        }
    }
    
    @IBAction private func startRecording(_ sender: NSButton) {
        startRecordingButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        screenRecorder.start()
    }
    
    @IBAction private func stopRecording(_ sender: NSButton) {
        startRecordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        playRecordingButton.isEnabled = true
        screenRecorder.stop()
        
        assert(FileManager.default.fileExists(atPath: videoDestination.path))
    }
    
    @IBAction private func playRecording(_ sender: NSButton) {
        assert(FileManager.default.fileExists(atPath: videoDestination.path))
        
        let player = AVPlayer(url: videoDestination)
        playerView.player = player
        player.play()
    }
}

import AVFoundation

/// NSCameraUsageDescription
/// https://github.com/nirix/swift-screencapture
/// https://github.com/wulkano/Aperture
final class ScreenRecorder: NSObject {
    
    private let destination: URL
    private let session: AVCaptureSession
    private let movieFileOutput: AVCaptureMovieFileOutput
    
    init(destination: URL) {
        self.destination = destination

        

        
        let session = AVCaptureSession()
        self.session = session
        session.sessionPreset = .high
        
        //AVCaptureDevice.devices()
//        Devices.enableDalDevices()

        
        print(AVCaptureDevice.devices(for: .muxed))
        assert(Devices.ios().count == 1)
        Devices.ios()
            .compactMap { try? AVCaptureDeviceInput(device: $0) }
            .filter { session.canAddInput($0) }
            .forEach { session.addInput($0) }
        
        
        /// CMIO_Unit_Input_Device.cpp:244:GetPropertyInfo CMIOUInputFromProcs::GetPropertyInfo() failed for id 1836411236, Error: -67456
        /// StreamCopyBufferQueue got an error from the plug-in routine, Error: 1852797029
        
//        let q = AVCaptureDevice.default(for: .video)!
//        let w = try! AVCaptureDeviceInput(device: q)
//        if session.canAddInput(w) {
//            session.addInput(w)
//        }
        
        //        let displayId = CGMainDisplayID()
        //        guard let input = AVCaptureScreenInput(displayID: displayId) else {
        //            fatalError()
        //            //            assertionFailure()
        //            //            return
        //        }
//        if session.canAddInput(input) {
//            session.addInput(input)
//        } else {
//            assertionFailure()
//        }
        
        movieFileOutput = AVCaptureMovieFileOutput()
        
        if session.canAddOutput(movieFileOutput) {
            session.addOutput(movieFileOutput)
        }
        
    }
    
    func start() {
        session.startRunning()
        movieFileOutput.startRecording(to: self.destination, recordingDelegate: self)
    }
    
    func stop() {
        movieFileOutput.stopRecording()
    }

}

extension ScreenRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        session.stopRunning()
    }
}











import AppKit
import AVFoundation
import CoreMediaIO

public struct Devices {
    public static func screen() -> [[String: Any]] {
        return NSScreen.screens.map {
            [
                // TODO: Use `NSScreen#localizedName` when targeting macOS 10.15
                "name": $0.name,
                "id": $0.id ?? 0
            ]
        }
    }
    
    public static func audio() -> [[String: String]] {
        return AVCaptureDevice.devices(for: .audio).map {
            [
                "name": $0.localizedName,
                "id": $0.uniqueID
            ]
        }
    }
    
    public static func iosInfo() -> [[String: String]] {
        return AVCaptureDevice.devices(for: .muxed)
            .filter { $0.localizedName == "iPhone" || $0.localizedName == "iPad" }
            .map {
                [
                    "name": $0.localizedName,
                    "id": $0.uniqueID
                ]
        }
    }
    
    public static func ios() -> [AVCaptureDevice] {
        return AVCaptureDevice.devices(for: .muxed)
            .filter { $0.localizedName.contains("iPhone") || $0.localizedName.contains("iPad") }
    }
    
    
    /// Enable access to iOS devices
    /// https://stackoverflow.com/a/30058966/5893286
    static func enableDalDevices() {
        var property = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster)
        )
        var allow: UInt32 = 1
        let sizeOfAllow = MemoryLayout<UInt32>.size
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &property, 0, nil, UInt32(sizeOfAllow), &allow)
    }
}














import AppKit
import AVFoundation

extension CMTimeScale {
    
    /// This is what Apple recommends
    static let video: CMTimeScale = 600
}

extension CMTime {
    init(videoFramesPerSecond: Int) {
        self.init(seconds: 1 / Double(videoFramesPerSecond), preferredTimescale: .video)
    }
}

extension CGDirectDisplayID {
    // TODO: check on switch for macMini
    //public static let main = CGMainDisplayID()
    public static var main: CGDirectDisplayID {
        return CGMainDisplayID()
    }
}

extension NSScreen {
    private func infoForCGDisplay(_ displayID: CGDirectDisplayID, options: Int) -> [AnyHashable: Any]? {
        var iterator: io_iterator_t = 0
        
        let result = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator)
        guard result == kIOReturnSuccess else {
            assertionFailure("Could not find services for IODisplayConnect: \(result)")
            return nil
        }
        
        var service = IOIteratorNext(iterator)
        while service != 0 {
            
            guard
                let info = IODisplayCreateInfoDictionary(service, IOOptionBits(options)).takeRetainedValue() as? [AnyHashable: Any],
                let vendorID = info[kDisplayVendorID] as? UInt32,
                let productID = info[kDisplayProductID] as? UInt32
            else {
                assertionFailure()
                continue
            }
            
            if vendorID == CGDisplayVendorNumber(displayID) && productID == CGDisplayModelNumber(displayID) {
                return info
            }
            
            service = IOIteratorNext(iterator)
        }
        
        assertionFailure()
        return nil
    }
    
    var id: CGDirectDisplayID? {
        return deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
    }
    
    var name: String {
        guard let id = self.id, let info = infoForCGDisplay(id, options: kIODisplayOnlyPreferredName) else {
            assertionFailure()
            return "Unknown screen"
        }
        
        guard
            let localizedNames = info[kDisplayProductName] as? [String: Any],
            let name = localizedNames.values.first as? String
        else {
            assertionFailure()
            return "Unnamed screen"
        }
        
        return name
    }
}

extension Optional {
    
    func unwrapOrThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            assertionFailure()
            throw errorExpression()
        }
        
        return value
    }
}
