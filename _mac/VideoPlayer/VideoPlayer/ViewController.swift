//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Bondar Yaroslav on 5/27/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import AVFoundation

//import AVKit


/// iOS: Video freezes when entering landscape in the simulator for plus models (I do not know about actual plus devices)
/// https://github.com/maknapp/vlckitSwiftSample
///
import VLCKit

class ViewController: NSViewController {
    
    private let vlcMediaPlayer = VLCMediaPlayer()
//    var overlayVC : PlayerOverlayVC!
    private let videoView = NSView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let downloadsDirectoryUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            assertionFailure()
            return
        }

        let filePath = downloadsDirectoryUrl.appendingPathComponent("Hellsing/Hellsing_01.mkv").path
//        let filePath = downloadsDirectoryUrl.appendingPathComponent("06. Аквамен (2013) [IMAX] BDRip 1080p [HEVC] 10 bit.mkv").path

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
        
        let media = VLCMedia(url: url)
        
        // Set media options
        // https://wiki.videolan.org/VLC_command-line_help
        //media.addOptions([
        //    "network-caching": 300
        //])
        
        vlcMediaPlayer.media = media
        
        vlcMediaPlayer.delegate = self
        
        
        /// https://code.videolan.org/videolan/VLCKit/issues/82
        /// for VLCVideoView
        //videoView.fillScreen = true
        
        videoView.frame = view.bounds
        videoView.autoresizingMask = [.height, .width]
        view.addSubview(videoView)
        vlcMediaPlayer.drawable = videoView
        
        /// enable debug logging from libvlc
        //vlcMediaPlayer.libraryInstance.debugLogging = true
        
        vlcMediaPlayer.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            
            guard let tracksInformation = media.tracksInformation as? [NSDictionary] else {
                assertionFailure()
                return
            }
            
            guard let videoTrack = tracksInformation.first(where: { dict in
                dict[VLCMediaTracksInformationType] as? String == VLCMediaTracksInformationTypeVideo
            }) else {
                assertionFailure()
                return
            }
            
            guard let width = videoTrack[VLCMediaTracksInformationVideoWidth] as? Int,
                let height = videoTrack[VLCMediaTracksInformationVideoHeight] as? Int else {
                assertionFailure()
                return
            }
            
            print(tracksInformation)
//            self.view.window?.aspectRatio = .init(width: width, height: height)
//            self.view.window?.titlebarAppearsTransparent = true
//            self.view.window?.styleMask.insert(.fullSizeContentView)
            
            // TODO: update window size
            self.view.window?.contentAspectRatio = .init(width: width, height: height)

            
            /// 2073600
            //VLCMediaTracksInformationSourceAspectRatio
            
//            print("-", media.state.rawValue)
            self.vlcMediaPlayer.position = 0.5
            //self.vlcMediaPlayer.pause()
            
            
        }

//        let range = Float(truncating: self.vlcMediaPlayer.media.length.value)/100
//        let perCent = (Float(currrentDuration) / range)
//        self.vlcMediaPlayer.position = Float (perCent)
        
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    
//    private var player: AVPlayer!
//    private var playerLayer: AVPlayerLayer!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//        // MARK: - setup item
//
//        guard let downloadsDirectoryUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
//            assertionFailure()
//            return
//        }
//
////        let filePath = downloadsDirectoryUrl.appendingPathComponent("Hellsing/Hellsing_01.mkv").path
//        let filePath = downloadsDirectoryUrl.appendingPathComponent("JFK.DirCut.1991_HDRip__[scarabey.org].avi").path
//
//        /// don't fogget to add to "Copy Bundle Resources"
//        /// https://stackoverflow.com/a/43129166/5893286
////        guard let filePath = Bundle.main.path(forResource: "video_test.mp4", ofType: nil) else {
////            assertionFailure()
////            return
////        }
//
////        guard let url = URL(fileURLWithPath: filePath.path) else {
////            assertionFailure()
////            return
////        }
//        let url = URL(fileURLWithPath: filePath)
//
//        // MARK: - setup player
//        let player = AVPlayer()
////        let player = AVPlayer(url: url)
//        player.volume = 1
//        self.player = player
//
//        if #available(OSX 10.12, *), #available(iOS 10.0, *) {
//            player.automaticallyWaitsToMinimizeStalling = false
//        }
//
//        let playerItem = AVPlayerItem(url: url)
////        if playerItem.canPlayFastForward {
////        }
//        player.replaceCurrentItem(with: playerItem)
//
//        // MARK: - video layer
//        /// to activate view.layer
//        view.wantsLayer = true
//
//        /// https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/creating_a_basic_video_player_macos
//        let playerView = AVPlayerView()
//        playerView.player = player
////        playerView.showsFullScreenToggleButton = true
////        playerView.showsSharingServiceButton = true
//
//        /// replace buttons. only for "controlsStyle = .floating"
//        //playerView.showsFrameSteppingButtons = true
//
//        playerView.controlsStyle = .floating
//
//        playerView.frame = view.bounds
//        playerView.autoresizingMask = [.height, .width]
//        view.addSubview(playerView)
//
////        let playerLayer = AVPlayerLayer(player: player)
////        playerLayer.frame = view.bounds
////        playerLayer.autoresizingMask = [.layerHeightSizable, .layerWidthSizable]
////        playerLayer.backgroundColor = NSColor.blue.cgColor
////
////        view.layer?.addSublayer(playerLayer)
////        self.playerLayer = playerLayer
//
//        // MARK: - play
//        if #available(OSX 10.12, *), #available(iOS 10.0, *) {
//            player.playImmediately(atRate: 1)
//        } else {
//            player.play()
//        }
//    }
    
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

//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
//

}

extension ViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        guard let player = aNotification.object as? VLCMediaPlayer else {
            assertionFailure()
            return
        }
        assert(player == vlcMediaPlayer)
        print("player state changed to:", player.state.rawValue)
    }
}
