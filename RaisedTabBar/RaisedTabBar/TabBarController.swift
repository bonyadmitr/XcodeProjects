import UIKit

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

protocol TabBarRaisedHandler: class {
    var tabBarRaisedActions: [TabBarRaisedAction] { get }
}

/// can be added context (example `let handler: (UIViewController) -> Void`)
/// can be added enum ActionType to have and custom action and array of actions
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

/// can be created custom class for nav bar vc in tab bar vc
extension UINavigationController: TabBarRaisedHandler {
    var tabBarRaisedActions: [TabBarRaisedAction] {
        // TODO: assert empty
        return (topViewController as? TabBarRaisedHandler)?.tabBarRaisedActions ?? []
    }
}
