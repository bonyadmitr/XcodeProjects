import AVFoundation

/// NSCameraUsageDescription
/// https://github.com/nirix/swift-screencapture
/// https://github.com/wulkano/Aperture
final class ScreenRecorder: NSObject {
    
    let session: AVCaptureSession
    private let movieFileOutput: AVCaptureMovieFileOutput
    
    override init() {
        
        let session = AVCaptureSession()
        self.session = session
        session.sessionPreset = .high
        
        //AVCaptureDevice.devices()
        //        Devices.enableDalDevices()
        
        
        print(AVCaptureDevice.devices(for: .muxed))
        assert(Devices.ios().count == 1)
        Devices.ios()
            //.filter { $0.hasMediaType(.video) }
            .compactMap { try? AVCaptureDeviceInput(device: $0) }
            .filter { session.canAddInput($0) }
            .forEach { session.addInput($0) }
        
        //        NotificationCenter.default.addObserver(forName: .AVCaptureSessionRuntimeError, object: nil, queue: nil) { notification in
        //            print("- error session\n", notification)
        //        }
        
        //AVCaptureSessionErrorKey.description
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
        
        super.init()
    }
    
    func startRecording(to outputFileURL: URL) {
        session.startRunning()
        movieFileOutput.startRecording(to: outputFileURL, recordingDelegate: self)
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
