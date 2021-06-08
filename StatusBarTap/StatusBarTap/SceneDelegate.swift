//
//  SceneDelegate.swift
//  StatusBarTap
//
//  Created by Yaroslav Bondr on 03.03.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "StatusBarTap"), object: nil, queue: nil) { _ in
            print("StatusBarTap")
            UIApplication.getTopViewController()?.view
                /// maybe needs to find 1 top scrollView
                .allSubviews(of: UIScrollView.self)
                .forEach { $0.scrollToTop() }
            
        }
        
        
//        guard let scene = (scene as? UIWindowScene) else { return }
//        let window = CustomWindow(windowScene: scene)
//        window.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
//        window.statusBarTapped = {
//            print("status bar tapped. called in SceneDelegate")
//        }
//        
//        self.window = window
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// MARK: - !!!


/// https://stackoverflow.com/a/31673478/5893286
@objc(MyApplication)
final class MyApplication: UIApplication {

//    override func sendEvent(_ event: UIEvent) {
//        super.sendEvent(event)
//    }

//    override init() {
//        super.init()
//
//    }
}



/// not owkring
//override func sendEvent(_ event: UIEvent) {
//    super.sendEvent(event)
//
//    guard event.type == .touches, let touches = event.allTouches else {
//        return
//    }
//
//    for touch in touches {
//        //print(touch.phase.rawValue)
//
//        /// inspired https://github.com/aaronabentheuer/AAWindow/blob/master/AAWindow.swift
//        /// not working for app switcher, notification center
//        /// UIScreenEdgePanGestureRecognizer cannot prevent open any system center
//        if touch.phase == .began {
//            let statuBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 20
//            print(touch.location(in: self).y, statuBarHeight, touch.location(in: self).y - statuBarHeight)
//            if touch.location(in: self).y - statuBarHeight <= 0 {
//                print("status bar")
//            }
//        }
//    }
//
//}
final class CustomWindow: UIWindow {
    
    var statusBarTapped: () -> Void = {}
    
    private let scrollView = UIScrollView()
    
    // TODO: check for needs weak
    /// rootViewController will change and scrolls will be changed.
    /// will not work for inner VC and added scrollView later
    private var scrolls: [UIScrollView]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setup()
    }
    
    private func setup() {
        scrollView.frame = frame
        scrollView.contentSize.height = frame.height + 1
        scrollView.contentOffset.y = 1
        scrollView.delegate = self
        addSubview(scrollView)
    }
    
    override var rootViewController: UIViewController? {
        didSet {
            // TODO: find
            scrolls = rootViewController?.view.allSubviews(of: UIScrollView.self)
            scrolls?.forEach { $0.scrollsToTop = false }
        }
    }

}

extension CustomWindow: UIScrollViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrolls?.forEach {
            /// https://stackoverflow.com/a/46615230/5893286
            $0.setContentOffset(CGPoint(x: 0, y: -$0.adjustedContentInset.top), animated: true)
        }
        statusBarTapped()
        return false
    }
}

extension UIScrollView {
    func scrollToTop() {
        setContentOffset(CGPoint(x: 0, y: -adjustedContentInset.top), animated: true)
    }
}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIView {
    
    func firstSubview<T: UIView>(of: T.Type) -> T? {
        
        func checkViewForType(_ inputView: UIView) -> T? {
            if let view = inputView as? T {
                return view
            }
            for view in inputView.subviews {
                if let view2 = checkViewForType(view) {
                    return view2
                }
            }
            return nil
        }
        
        for view in subviews {
            if let view2 = checkViewForType(view) {
                return view2
            }
        }
        return nil
    }
    
    /// returns all subviews except self
    func allSubviews<T: UIView>(of: T.Type) -> [T] {
        var typeSubviews = [T]()
        
        func checkViewForType(_ view: UIView) {
            if let view = view as? T {
                typeSubviews.append(view)
            }
            view.subviews.forEach { checkViewForType($0) }
        }
        subviews.forEach { checkViewForType($0) }
        return typeSubviews
    }

}

