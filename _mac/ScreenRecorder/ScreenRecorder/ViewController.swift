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
        
        
        if AVCaptureDevice.devices(for: .muxed).count == 0 {
            NotificationCenter.default.addObserver(forName: .AVCaptureDeviceWasConnected, object: nil, queue: nil) { notification in
                //print(AVCaptureDevice.devices(for: .muxed))
                //print(notification.object as! AVCaptureDevice)
                print("- new device")
                
                self.addVideoHandler()
            }
        } else {
            addVideoHandler()
        }
        
        Devices.enableDalDevices()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        CALayer.performWithoutAnimation() {
            previewLayer?.frame = playerView.bounds
        }
    }
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private func addVideoHandler() {
        guard self.previewLayer == nil else {
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.screenRecorder.session)
        self.previewLayer = previewLayer
        previewLayer.videoGravity = .resizeAspect
        previewLayer.frame = self.playerView.bounds
        self.playerView.wantsLayer = true
        self.playerView.layer?.addSublayer(previewLayer)
        
        self.screenRecorder.session.startRunning()
    }
    
    @IBAction private func startRecording(_ sender: NSButton) {
        if FileManager.default.fileExists(atPath: videoDestination.path) {
            try? FileManager.default.removeItem(atPath: videoDestination.path)
        }
        startRecordingButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        screenRecorder.start()
    }
    
    @IBAction private func stopRecording(_ sender: NSButton) {
        startRecordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        playRecordingButton.isEnabled = true
        screenRecorder.stop()
        playRecording(nil)
        assert(FileManager.default.fileExists(atPath: videoDestination.path))
    }
    
    @IBAction private func playRecording(_ sender: NSButton?) {
        assert(FileManager.default.fileExists(atPath: videoDestination.path))
        
        let player = AVPlayer(url: videoDestination)
        playerView.player = player
        player.play()
    }
}

extension CALayer {
    
    /// https://stackoverflow.com/a/33961937/5893286
    static func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
