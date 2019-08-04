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

final class VideoPlayerView: NSView {
    
    private let vlcMediaPlayer = VLCMediaPlayer()
    private let videoView = NSView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    private func setup() {
        loadFile()
        setupMediaPlayer()
        launchMediaPlayer()
    }
    
    private func launchMediaPlayer() {
        vlcMediaPlayer.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            
            guard let tracksInformation = self.vlcMediaPlayer.media.tracksInformation as? [NSDictionary] else {
                assertionFailure()
                return
            }
            
            guard let videoTrack = tracksInformation.first(where: { dict in
                dict[VLCMediaTracksInformationType] as? String == VLCMediaTracksInformationTypeVideo
            }) else {
                assertionFailure()
                return
            }
            
            guard
                let width = videoTrack[VLCMediaTracksInformationVideoWidth] as? Int,
                let height = videoTrack[VLCMediaTracksInformationVideoHeight] as? Int
            else {
                assertionFailure()
                return
            }
            
            print(tracksInformation)
            //            self.view.window?.aspectRatio = .init(width: width, height: height)
            //            self.view.window?.titlebarAppearsTransparent = true
            //            self.view.window?.styleMask.insert(.fullSizeContentView)
            
            // TODO: update window size
            self.window?.contentAspectRatio = .init(width: width, height: height)
            
            
            /// 2073600
            //VLCMediaTracksInformationSourceAspectRatio
            
            //            print("-", media.state.rawValue)
            self.vlcMediaPlayer.position = 0.5
            //self.vlcMediaPlayer.pause()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupVideoView()
            }
        }
        
        //        let range = Float(truncating: self.vlcMediaPlayer.media.length.value)/100
        //        let perCent = (Float(currrentDuration) / range)
        //        self.vlcMediaPlayer.position = Float (perCent)
        
    }
    
    private func loadFile() {
//        guard let downloadsDirectoryUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
//            assertionFailure()
//            return
//        }
        
//        let filePath = downloadsDirectoryUrl.appendingPathComponent("Hellsing/Hellsing_01.mkv").path
        //        let filePath = downloadsDirectoryUrl.appendingPathComponent("06. Аквамен (2013) [IMAX] BDRip 1080p [HEVC] 10 bit.mkv").path
        
        /// don't fogget to add to "Copy Bundle Resources"
        /// https://stackoverflow.com/a/43129166/5893286
        guard let filePath = Bundle.main.path(forResource: "video_test.mp4", ofType: nil) else {
            assertionFailure()
            return
        }
        
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
    }
    
    private func setupVideoView() {
        /// https://code.videolan.org/videolan/VLCKit/issues/82
        /// for VLCVideoView but it is not working
        //videoView.fillScreen = true
        
        videoView.frame = bounds
        videoView.autoresizingMask = [.height, .width]
        addSubview(videoView)
    }
    
    private func setupMediaPlayer() {
        /// enable debug logging from libvlc
        //vlcMediaPlayer.libraryInstance.debugLogging = true
        
        vlcMediaPlayer.delegate = self
        vlcMediaPlayer.drawable = videoView
    }
    
    deinit {
        /// stop player before deinit. otherwise will be crash
        vlcMediaPlayer.stop()
    }
}

extension VideoPlayerView: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        guard let player = aNotification.object as? VLCMediaPlayer else {
            assertionFailure()
            return
        }
        assert(player == vlcMediaPlayer)
        print("player state changed to:", player.state.rawValue)
    }
    
    
}


class ViewController: NSViewController {
    
    override func loadView() {
        view = VideoPlayerView()
    }
}
