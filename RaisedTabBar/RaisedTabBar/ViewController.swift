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
        // Do any additional setup after loading the view.
    }


}

import UIKit

class MainTabBar: UITabBar {
    
    private let middleButton = UIButton()
    
    override var items: [UITabBarItem]? {
        didSet {
            // TODO: check is called
            updateItemOffset()
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
        updateItemOffset()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden {
            return super.hitTest(point, with: event)
        }
        
        let from = point
        let to = middleButton.center
        
        // TODO: why is 39. mb 35
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39 ? middleButton : super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: 0)
    }
    
    private func setupMiddleButton() {
        // TODO: var size
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = .blue
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        middleButton.addTarget(self, action: #selector(onMiddleButton), for: .touchUpInside)
        addSubview(middleButton)
    }
    
    @objc private func onMiddleButton() {
        // TODO: handler
        print("hi")
    }
    
    private func updateItemOffset() {
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
