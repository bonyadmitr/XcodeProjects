import UIKit

final class Factory {
    func main() -> UIViewController {
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
}
