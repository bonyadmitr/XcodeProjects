import UIKit

// TODO: top controller + custom vc
// TODO: rootVC router
// TODO: login router
// TODO: split controller navigation
extension UITabBarController {
    
    enum Tab: Int {
        case first = 0
        case second
    }
    
    func isSelected(_ tab: Tab) -> Bool {
        selectedIndex == tab.rawValue
        
        /// #2. for more 5
        //selectedViewController == viewControllers?[tab.rawValue]
    }
    
    func select(_ tab: Tab) {
        safeSelect(at: tab.rawValue)
    }
    
    private func safeSelect(at index: Int) {
        if let viewControllers = viewControllers, viewControllers.count >= index + 1 {
            selectedIndex = index
        }
        
        /// #2. more 5 https://stackoverflow.com/a/5413606/5893286
        /// if the index maps to a tab within the More view controller (should you have more than five tabs), this will not work. In that case, use -setSelectedViewController
        //if controllers.count >= index + 1 {
        //    selectedViewController = controllers[index]
        //}
    }
    
    //var controllers: [UIViewController] {
    //    return viewControllers ?? []
    //}
    
}

extension UINavigationController {
    
    /// source https://stackoverflow.com/a/25230169/5893286
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func replaceTopViewController(_ viewController: UIViewController, animated: Bool) {
        var currentStack = viewControllers
        if currentStack.isEmpty {
            pushViewController(viewController, animated: animated)
        } else {
            currentStack[currentStack.count - 1] = viewController
            setViewControllers(currentStack, animated: animated)
        }
    }
    
}
