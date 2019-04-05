import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navVC1 = UINavigationController(rootViewController: factory.actions())
        navVC1.navigationBar.isTranslucent = false
        viewControllers = [navVC1, factory.vc1(), factory.vc2()]
    }
    
    func show1() {
        selectedIndex = 0
    }
    
    func show2() {
        selectedIndex = 1
    }
    
    func show3() {
        selectedIndex = 1
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

final class LoginController: LabelController {
    
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        label.text = "Login"
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton.sizeToFit()
        loginButton.frame = CGRect(x: 20, y: 20, width: view.bounds.width - 20 * 2, height: 44)
        
    }
    
    @objc private func login() {
        isLoggedIn = true
        router.openMain()
    }
}

final class ActionsController: UIViewController {
    
    private let button1 = UIButton(type: .system)
    private let button2 = UIButton(type: .system)
    private let button3 = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "actions"
        view.backgroundColor = UIColor.lightGray
        
        view.addSubview(button1)
        button1.setTitle("push", for: .normal)
        button1.addTarget(self, action: #selector(push), for: .touchUpInside)
        
        view.addSubview(button2)
        button2.setTitle("present", for: .normal)
        button2.addTarget(self, action: #selector(presentSome), for: .touchUpInside)
        
        view.addSubview(button3)
        button3.setTitle("change tab", for: .normal)
        button3.addTarget(self, action: #selector(changeTab), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let yOffset: CGFloat = 20
        let xOffset: CGFloat = 20
        
        button1.sizeToFit()
        button1.frame = CGRect(x: xOffset, y: yOffset, width: view.bounds.width - xOffset * 2, height: 44)
        
        button2.sizeToFit()
        button2.frame = CGRect(x: xOffset, y: button1.frame.maxY + yOffset, width: view.bounds.width - xOffset * 2, height: 44)
        
        button3.sizeToFit()
        button3.frame = CGRect(x: xOffset, y: button2.frame.maxY + yOffset, width: view.bounds.width - xOffset * 2, height: 44)
        
    }
    
    @objc func push() {
        navigationController?.pushViewController(factory.vc1(), animated: true)
    }
    
    @objc private func presentSome() {
        let vc = factory.navVCWithCancel(root: factory.vc2())
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func changeTab() {
        router.show2()
    }
}
