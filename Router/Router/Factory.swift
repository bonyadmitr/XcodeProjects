import UIKit

final class Factory {
    func main() -> TabBarController {
        return TabBarController()
    }
    
    func login() -> UIViewController {
        return LoginController()
    }
    
    func vc1() -> UIViewController {
        let vc = LabelController()
        vc.label.text = "111"
        vc.title = "111"
        vc.view.backgroundColor = UIColor.magenta
        return vc
    }
    
    func vc2() -> UIViewController {
        let vc = LabelController()
        vc.label.text = "222"
        vc.title = "222"
        vc.view.backgroundColor = UIColor.cyan
        return vc
    }
    
    func actions() -> ActionsController {
        return ActionsController()
    }
    
    func navVC(root: UIViewController) -> UINavigationController {
        let navVC1 = UINavigationController(rootViewController: root)
        navVC1.navigationBar.isTranslucent = false
        return navVC1
    }
    
    func navVCWithCancel(root: UIViewController) -> UINavigationController {
        let navVC = self.navVC(root: root)
        root.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(navVC.dismissSelf))
        return navVC
    }
}

extension UIViewController {
    @objc func dismissSelf() {
        if let navVC = navigationController {
            navVC.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
