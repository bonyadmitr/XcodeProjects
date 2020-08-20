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

extension ViewController: RaisedTabBarHandler {
    func onRaisedButton() {
        print("onRaisedButton ViewController")
    }
}


struct TabBarRaisedAction {
    let title: String
    let handler: () -> Void
}

extension TabBarRaisedAction {
    static let open = TabBarRaisedAction(title: "Open") {
        print("open")
    }
    
    static let add = TabBarRaisedAction(title: "Add") {
        print("add")
    }
}

protocol TabBarRaisedHandler: class {
    var tabBarRaisedActions: [TabBarRaisedAction] { get }
}

final class TabBarController: RaisedTabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        onRaisedButtonHandler = { [weak self] in
            if let vc = self?.selectedViewController as? TabBarRaisedHandler, !vc.tabBarRaisedActions.isEmpty {
                self?.alert(for: vc.tabBarRaisedActions)
            } else {
                print("default onRaisedButtonHandler")
            }
        }
    }
    
    private func alert(for actions: [TabBarRaisedAction]) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach { action in
            alertVC.addAction(.init(title: action.title, style: .default) { _ in
                action.handler()
            })
        }
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

protocol RaisedTabBarHandler: class {
    func onRaisedButton()
}

class RaisedTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupMiddleButton()
        updateItemsOffset()
        
        onRaisedButtonHandler = { [weak self] in
            if let vc = self?.selectedViewController as? RaisedTabBarHandler {
                vc.onRaisedButton()
            } else {
                print("default onRaisedButtonHandler")
            }
        }
        
    }
    
    var onRaisedButtonHandler: () -> Void = {}
    private let raisedButton = UIButton()
    
    override var viewControllers: [UIViewController]? {
        didSet {
            updateItemsOffset()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        raisedButton.center = CGPoint(x: tabBar.center.x, y: 0)
        tabBar.bringSubviewToFront(raisedButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if tabBar.isHidden {
            super.touchesBegan(touches, with: event)
            return
        }
        
        guard let touchLocation = touches.first?.location(in: view) else {
            assertionFailure("touch will be always inside self")
            return
        }
        
        let onButton = view.convert(touchLocation, to: raisedButton)
        
        //if raisedButton.point(inside: onButton, with: event) {
        if raisedButton.bounds.contains(onButton) {
            onRaisedButtonHandler()
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    private func setupMiddleButton() {
        raisedButton.frame.size = CGSize(width: 70, height: 70)
        raisedButton.backgroundColor = .blue
        raisedButton.layer.cornerRadius = raisedButton.bounds.midX
        raisedButton.layer.masksToBounds = true
        raisedButton.center = CGPoint(x: tabBar.center.x, y: 0)
        raisedButton.addTarget(self, action: #selector(onRaisedButton), for: .touchUpInside)
        tabBar.addSubview(raisedButton)
    }
    
    @objc private func onRaisedButton() {
        onRaisedButtonHandler()
    }
    
    private func updateItemsOffset() {
        guard let tabItems = tabBar.items else {
            return
        }
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


import UIKit

/// article https://equaleyes.com/blog/2017/09/04/the-common-raised-center-button-problems-in-tabbar/
/// another solution https://github.com/11Shraddha/STTabbar/blob/master/STTabbar/Classes/STTabbar.swift
/// article https://programmer.help/blogs/swift-special-custom-uitabbar-uitabbarcontroller-and-uinavigation-controller.html
final class RaisedTabBar: UITabBar {
    
    var onRaisedButtonHandler: () -> Void = {}
    private let raisedButton = UIButton()
    
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
        let to = raisedButton.center
        let len = sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
        return len <= raisedButton.bounds.midX ? raisedButton : super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        raisedButton.center = CGPoint(x: center.x, y: 0)
    }
    
    private func setupMiddleButton() {
        raisedButton.frame.size = CGSize(width: 70, height: 70)
        raisedButton.backgroundColor = .blue
        raisedButton.layer.cornerRadius = raisedButton.bounds.midX
        raisedButton.layer.masksToBounds = true
        raisedButton.center = CGPoint(x: center.x, y: 0)
        raisedButton.addTarget(self, action: #selector(onRaisedButton), for: .touchUpInside)
        addSubview(raisedButton)
    }
    
    @objc private func onRaisedButton() {
        onRaisedButtonHandler()
    }
    
    private func updateItemsOffset() {
        guard let tabItems = items else {
            return
        }
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
