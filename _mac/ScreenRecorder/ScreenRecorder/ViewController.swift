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

        stopRecordingButton.isEnabled = false
        playRecordingButton.isEnabled = FileManager.default.fileExists(atPath: videoDestination.path)
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

/// https://github.com/nirix/swift-screencapture
final class ScreenRecorder: NSObject {
    
    private let destination: URL
    private let session: AVCaptureSession
    private let movieFileOutput: AVCaptureMovieFileOutput
    
    init(destination: URL) {
        self.destination = destination
        
        
        let displayId = CGMainDisplayID()
        
        guard let input = AVCaptureScreenInput(displayID: displayId) else {
            fatalError()
            //            assertionFailure()
            //            return
        }
        
        session = AVCaptureSession()
        session.sessionPreset = .high
        
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            assertionFailure()
        }
        
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
