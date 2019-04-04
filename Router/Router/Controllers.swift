import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [factory.vc1(), factory.vc2()]
    }
}

final class LoginController: LabelController {
    
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        label.text = "Login"
        
        //        loginButton.setTitleColor(UIColor.blue, for: .normal)
        //        loginButton.backgroundColor = .red
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(loginButton)
        //        loginButton.frame = CGRect(x: 20, y: 20, width: view.bounds.width - 20 * 2, height: 44)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton.sizeToFit()
        loginButton.frame = CGRect(x: 20, y: 20, width: view.bounds.width - 20 * 2, height: 44)
        
    }
    
    @objc private func login() {
        router.openMain()
    }
}

final class MainController: LabelController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Main"
    }
}

class LabelController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.sizeToFit()
        label.center = view.center
    }
}
