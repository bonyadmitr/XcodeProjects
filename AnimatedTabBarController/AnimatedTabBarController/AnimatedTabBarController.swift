import UIKit

/// article https://vaseks.me/animation-tabbar-swift-ios/
final class AnimatedTabBarController: UITabBarController {
    
    override var selectedIndex: Int {
        didSet {
            guard let item = tabBar.items?[selectedIndex] else {
                assertionFailure()
                return
            }
            animateTabBarItem(item)
        }
    }
    
    private func animateTabBarItem(_ item: UITabBarItem) {
        item.view?.layer.add(Self.bounceAnimation, forKey: nil)
    }
    
}

// MARK: - UITabBarControllerDelegate
extension AnimatedTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // TODO: sound
        // TODO: vibration
        animateTabBarItem(item)
    }
    
}


extension UITabBarItem {
    
    /// UITabBarButton
    var view: UIControl? {
        return value(forKey: "view") as? UIControl
    }
    
    /// inspired https://stackoverflow.com/a/45320350/5893286
    var badgeView: UIView? {
        return view?.subviews.first { String(describing: type(of: $0)) == "_UIBadgeView" }
    }
    
}


// MARK: - badgeValue

/// custom badge https://stackoverflow.com/q/16274017/5893286
///
/// custom badge https://iosexample.com/add-emojis-and-colored-dots-as-badges-for-your-tab-bar-buttons/
/// source  https://github.com/odedharth/SuperBadges/blob/master/SuperBadges/Classes/SuperBadges.swift

extension UITabBarController {
    
    static let bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    func incrementBadgeNumber(for addBadgeNumber: Int = 0, at index: Int, animated: Bool = true) {
        if let badgeValue = getBadgeValue(at: index), var number = Int(badgeValue) {
            number += 1 + addBadgeNumber
            set(badgeNumber: number, at: index, animated: animated)
        } else {
            set(badgeValue: "1", at: index, animated: animated)
        }
    }
    
    func set(badgeNumber: Int, at index: Int, animated: Bool = true) {
        set(badgeValue: String(badgeNumber), at: index, animated: animated)
    }
    
    func set(badgeValue: String, at index: Int, animated: Bool = true) {
        if let tabItems = tabBar.items, tabItems.count >= index + 1 {
            let tabItem = tabItems[index]
            /// badgeValue https://stackoverflow.com/a/43111460/5893286
            tabItem.badgeValue = badgeValue
            
            if animated {
                tabItem.badgeView?.layer.add(Self.bounceAnimation, forKey: nil)
            }
        }
    }
    
    func getBadgeValue(at index: Int) -> String? {
        if let tabItems = tabBar.items, tabItems.count >= index + 1 {
            let tabItem = tabItems[index]
            /// The default value is nil
            return tabItem.badgeValue
        } else {
            return nil
        }
    }
    
}
