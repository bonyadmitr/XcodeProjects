//
//  ViewController.swift
//  YoutubeView
//
//  Created by Yaroslav Bondar on 21.05.2021.
//

import UIKit
import youtube_ios_player_helper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}


extension ViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        
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
