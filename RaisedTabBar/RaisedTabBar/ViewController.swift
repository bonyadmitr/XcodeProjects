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
    
    private var middleButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMiddleButton()
        
        // TODO: dynamic, 2/4 items
        guard let tabItems = items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: 15, vertical: 0)

    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return super.hitTest(point, with: event)
        }
        
        let from = point
        let to = middleButton.center
        
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39 ? middleButton : super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
    }
    
    func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = .blue
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        middleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        addSubview(middleButton)
    }
    
    @objc func test() {
        print("my name is jeff")
    }
}
