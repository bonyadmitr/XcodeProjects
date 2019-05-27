//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Bondar Yaroslav on 5/27/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import AVFoundation

import AVKit

class ViewController: NSViewController {

    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // MARK: - setup item
        
        guard let downloadsDirectoryUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            assertionFailure()
            return
        }
        
//        let filePath = downloadsDirectoryUrl.appendingPathComponent("Hellsing/Hellsing_01.mkv").path
        let filePath = downloadsDirectoryUrl.appendingPathComponent("test/video_test.mp4").path
        
        /// don't fogget to add to "Copy Bundle Resources"
        /// https://stackoverflow.com/a/43129166/5893286
//        guard let filePath = Bundle.main.path(forResource: "video_test.mp4", ofType: nil) else {
//            assertionFailure()
//            return
//        }
        
//        guard let url = URL(fileURLWithPath: filePath.path) else {
//            assertionFailure()
//            return
//        }
        let url = URL(fileURLWithPath: filePath)
        
        // MARK: - setup player
        let player = AVPlayer()
//        let player = AVPlayer(url: url)
        player.volume = 1
        self.player = player
        
        if #available(OSX 10.12, *), #available(iOS 10.0, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)

        // MARK: - video layer
        /// to activate view.layer
        view.wantsLayer = true
        
        /// https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/creating_a_basic_video_player_macos
        let playerView = AVPlayerView()
        playerView.player = player
        playerView.frame = view.bounds
        playerView.autoresizingMask = [.height, .width]
        view.addSubview(playerView)
        
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer.autoresizingMask = [.layerHeightSizable, .layerWidthSizable]
//        playerLayer.backgroundColor = NSColor.blue.cgColor
//
//        view.layer?.addSublayer(playerLayer)
//        self.playerLayer = playerLayer
        
        // MARK: - play
        if #available(OSX 10.12, *), #available(iOS 10.0, *) {
            player.playImmediately(atRate: 1)
        } else {
            player.play()
        }
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        playerLayer.frame = view.bounds
//    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
    
//    override func viewWillLayout() {
//        super.viewWillLayout()
//        playerLayer.frame = view.bounds
//    }
    
//    override func viewDidLayout() {
//        super.viewDidLayout()
//        playerLayer.frame = view.bounds
//    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

