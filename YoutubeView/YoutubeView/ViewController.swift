//
//  ViewController.swift
//  YoutubeView
//
//  Created by Yaroslav Bondar on 21.05.2021.
//

import UIKit
import youtube_ios_player_helper

/// you cannot override YTPlayerView
/// error: Received error rendering template: Error Domain=NSCocoaErrorDomain Code=258 "The file name is invalid."

/// github source https://github.com/youtube/youtube-ios-player-helper
/// doc + Best practices and limitations https://developers.google.com/youtube/v3/guides/ios_youtube_helper
/// old swift analog https://github.com/malkouz/youtube-ios-player-helper-swift

/// possible extensions https://developers.google.com/youtube/iframe_api_reference
/// example: playerView.playVideo() == playerView.webView?.evaluateJavaScript("player.playVideo();")
/// https://github.com/youtube/youtube-ios-player-helper/pull/338
extension YTPlayerView {
    
    func mute(completion: (() -> Void)? = nil) {
        webView?.evaluateJavaScript("player.mute();") { _, _ in
            /// needs some deleay for `isMuted`
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                completion?()
            }
            
        }
    }
    func unmute() {
        webView?.evaluateJavaScript("player.unMute();")
    }
    
    func isMuted(completion: @escaping (Bool) -> Void) {
        webView?.evaluateJavaScript("player.isMuted();") { result, error in
            let isMuted = result as? Int == 1
            completion(isMuted)
        }
    }
}

class ViewController: UIViewController {
    
    private let playerView = YTPlayerView()
    
    private let playerContainer = UIView()
    
    /// https://developers.google.com/youtube/player_parameters#Parameters
    private let playerParams = [
        "playsinline": 1, // 0 to play fullscreen
        //"autoplay": 1, // not working. use playerViewDidBecomeReady + playerView.playVideo()
        "iv_load_policy": 3, //3 to hide video anotations
        "controls": 2, // 0 to hide controls
//        "enablejsapi": 0, // 1 to enable API Javascript
        "fs": 0, //1 to show fullscreen button
//        "origin": "https://www.youtube.com", // security for enablejsapi
        "rel": 0, // 0 to stop play similar videos
        //"showinfo": 0, // deprecated as of 25/09/2018. 0 to hide video title
        "loop": 0, // 1 to loop video playing
        "modestbranding": 1, // 1 to remove youtube logo
        "cc_load_policy": 0 // субтитры
    ] as [String: Any]

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        
        playerView.isHidden = true
        playerView.delegate = self
        
        
        
        playerContainer.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.heightAnchor.constraint(equalTo: playerContainer.heightAnchor, multiplier: 1).isActive = true /// to hide controles `multiplier: 2`
        playerView.centerXAnchor.constraint(equalTo: playerContainer.centerXAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor).isActive = true
        //playerView.bottomAnchor.constraint(equalTo: playerContainer.bottomAnchor).isActive = true
        playerView.widthAnchor.constraint(equalTo: playerContainer.widthAnchor).isActive = true
        
        playerContainer.clipsToBounds = true
        playerContainer.frame = .init(x: 0, y: 100, width: view.frame.width, height: 300)
        view.addSubview(playerContainer)
//        playerView.frame = .init(x: 0, y: 100, width: view.frame.width, height: 500)
//        view.addSubview(playerView)
        
        
        let url = "https://www.youtube.com/watch?v=d5827e923Lw"
        let id = videoIdFrom(url: url)!
        
//        playerView.load(withVideoId: id)
        playerView.load(withVideoId: id, playerVars: playerParams)
        
        
        /// `webView` is nill before `load(withVideoId`
        //playerView.webView?.configuration.allowsPictureInPictureMediaPlayback = true /// default true
        playerView.webView?.configuration.allowsInlineMediaPlayback = true
    }
    
    func mute() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("mute()")
            self.playerView.mute {
                self.playerView.isMuted { isMuted in
                    print("isMuted", isMuted)
                }
            }
            
        }
        
    }


    func videoIdFrom(url: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: url.count)
        
        guard let result = regex?.firstMatch(in: url, range: range) else {
            return nil
        }
        
        return (url as NSString).substring(with: result.range)
    }

}


extension ViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
        
        /// to prevent showing loaded preview and it's blinking
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            playerView.isHidden = false
        }
        
        
        
//        let topView1 = playerView.firstSubview(whereView: { view in
//            return view.bounds.height == 57
//        })
//        topView1?.isHidden = true
//
//        let topView2 = playerView.firstSubview(whereView: { view in
//            return view.bounds.height == 110
//        })
//        topView2?.isHidden = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            let topView1 = playerView.firstSubview(whereView: { view in
//                return view.bounds.height == 57
//            })
//            topView1?.isHidden = true
//
//            let topView2 = playerView.firstSubview(whereView: { view in
//                return view.bounds.height == 110
//            })
//            topView2?.isHidden = true
//        }
//
//        print()
        
//        let topView2 = playerView.firstSubview(whereView: { view in
//            return view.bounds.height == 110
//        })
//        topView2?.isHidden = true
        
        //topView2?.superview?.isHidden = true
        
        
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
//        if state == .buffering {
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                let indicatorView = playerView.firstSubview(whereView: { view in
//                    return view.bounds.width == 64
//                })
//
//                indicatorView?.isHidden = true
//
//
//            }
//        }
        
//        let topView1 = playerView.firstSubview(whereView: { view in
//            return view.bounds.height == 57
//        })
//        topView1?.isUserInteractionEnabled = false
//        topView1?.isHidden = true
//
//        let topView2 = playerView.firstSubview(whereView: { view in
//            return view.bounds.height == 110
//        })
//        topView2?.isUserInteractionEnabled = false
//        topView2?.isHidden = true
        
        
//        switch state {
//        case .unstarted:
//            <#code#>
//        case .ended:
//            <#code#>
//        case .playing:
//            <#code#>
//        case .paused:
//            <#code#>
//        case .buffering:
//            <#code#>
//        case .cued:
//            <#code#>
//        case .unknown:
//            <#code#>
//        @unknown default:
//            <#code#>
//        }
    }
}

extension UIView {
    func firstSubview<T: UIView>(of: T.Type) -> T? {
        var viewWeAreLookingFor: T?
        
        func checkViewForType(_ view: UIView) {
            guard viewWeAreLookingFor == nil else {
                return
            }
            if let view = view as? T {
                viewWeAreLookingFor = view
                return
            }
            view.subviews.forEach {
                checkViewForType($0)
            }
        }
        subviews.forEach { checkViewForType($0) }
        return viewWeAreLookingFor
    }
    
    func firstSubview(whereView: (UIView) -> Bool) -> UIView? {
        var viewWeAreLookingFor: UIView?
        
        func checkViewForType(_ view: UIView) {
            guard viewWeAreLookingFor == nil else {
                return
            }
            if whereView(view) {
                viewWeAreLookingFor = view
                return
            }
            view.subviews.forEach {
                checkViewForType($0)
            }
        }
        subviews.forEach { checkViewForType($0) }
        return viewWeAreLookingFor
    }
    
}
