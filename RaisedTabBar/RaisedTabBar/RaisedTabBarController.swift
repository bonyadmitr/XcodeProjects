import UIKit

protocol RaisedTabBarHandler: class {
    func onRaisedButton()
}

// TODO: button customization
// TODO: tabBar shape
class RaisedTabBarController: UITabBarController {
    
    enum EventType {
        case touchUpInside
        case touchDownInside
    }
    
    var eventType = EventType.touchUpInside
    var onRaisedButtonHandler: () -> Void = {}
    let raisedButton = UIButton(type: .custom)
    
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
        if eventType == .touchDownInside && !handleOnButton(in: touches) {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if eventType == .touchUpInside && !handleOnButton(in: touches) {
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if eventType == .touchUpInside && !handleOnButton(in: touches) {
            super.touchesCancelled(touches, with: event)
        }
    }
    
    func handleOnButton(in touches: Set<UITouch>) -> Bool {
        if tabBar.isHidden {
            return false
        }
        
        guard let touchLocation = touches.first?.location(in: view) else {
            assertionFailure("touch will be always inside self")
            return false
        }
        
        let onButton = view.convert(touchLocation, to: raisedButton)
        
        //if raisedButton.point(inside: onButton, with: event) {
        if raisedButton.bounds.contains(onButton) {
            onRaisedButtonHandler()
            return true
        } else {
            return false
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
