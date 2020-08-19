//
//  ViewController.swift
//  RaisedTabBar
//
//  Created by Bondar Yaroslav on 8/17/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add tab br controller
        // TODO: add alert sheet for Raisedbutton for different controllers
    }


}


import UIKit

/// article https://equaleyes.com/blog/2017/09/04/the-common-raised-center-button-problems-in-tabbar/
/// another solution https://github.com/11Shraddha/STTabbar/blob/master/STTabbar/Classes/STTabbar.swift
final class RaisedTabBar: UITabBar {
    
    private let middleButton = UIButton()
    
    override var items: [UITabBarItem]? {
        didSet {
            // TODO: check is called
            updateItemsOffset()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupMiddleButton()
        updateItemsOffset()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden {
            return super.hitTest(point, with: event)
        }
        
        let from = point
        let to = middleButton.center
        
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2)) <= middleButton.bounds.midX ? middleButton : super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: center.x, y: 0)
    }
    
    private func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = .blue
        middleButton.layer.cornerRadius = middleButton.bounds.midX
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: center.x, y: 0)
        middleButton.addTarget(self, action: #selector(onMiddleButton), for: .touchUpInside)
        addSubview(middleButton)
    }
    
    @objc private func onMiddleButton() {
        // TODO: handler
        print("hi")
    }
    
    private func updateItemsOffset() {
        guard let tabItems = items else { return }
        if tabItems.count == 2 {
            tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
            tabItems[1].titlePositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
            // TODO: check for 4
        } else if tabItems.count == 4 {
            tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
            tabItems[1].titlePositionAdjustment = UIOffset(horizontal: -7, vertical: 0)
            tabItems[3].titlePositionAdjustment = UIOffset(horizontal: 7, vertical: 0)
            tabItems[4].titlePositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
        }
    }
    
}
