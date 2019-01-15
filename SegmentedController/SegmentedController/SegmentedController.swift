import UIKit

final class SegmentedController: UIViewController {
    
    private let topView = UIView()
    private let contanerView = UIView()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.tintColor = UIColor.magenta
        return segmentedControl
    }()
    
    private var viewControllers: [UIViewController] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        topView.backgroundColor = .white
        contanerView.backgroundColor = .white
        
        view.addSubview(topView)
        topView.addSubview(segmentedControl)
        view.addSubview(contanerView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        contanerView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let edgeConstant: CGFloat = 35
        segmentedControl.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: edgeConstant).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -edgeConstant).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        contanerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        contanerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        contanerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        contanerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        segmentedControl.addTarget(self, action: #selector(controllerDidChange), for: .valueChanged)
        
//        NSLayoutConstraint.activate([
//            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            topView.heightAnchor.constraint(equalToConstant: 50),
//
//            segmentedControl.leadingAnchor.constraint(equalTo: contanerView.leadingAnchor, constant: edgeConstant),
//            segmentedControl.trailingAnchor.constraint(equalTo: contanerView.trailingAnchor, constant: edgeConstant),
//            segmentedControl.centerYAnchor.constraint(equalTo: contanerView.centerYAnchor),
//
//            contanerView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
//            contanerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            contanerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            contanerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        vc1.title = "Title 1"
        viewControllers.append(vc1)
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .blue
        vc2.title = "Title 2"
        viewControllers.append(vc2)

        
        selectController(at: 0)
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        //segmentedControl.removeAllSegments()
        assert(!viewControllers.isEmpty, "should not be empty")
        
        for (index, controller) in viewControllers.enumerated() {
            segmentedControl.insertSegment(withTitle: controller.title, at: index, animated: false)
        }
        
        /// selectedSegmentIndex == -1 after removeAllSegments
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc private func controllerDidChange(_ sender: UISegmentedControl) {
        selectController(at: sender.selectedSegmentIndex)
    }
    
    private func selectController(at selectedIndex: Int) {
        guard selectedIndex < viewControllers.count else {
            assertionFailure()
            return
        }
        
        childViewControllers.forEach { $0.removeFromParentVC() }
        add(childController: viewControllers[selectedIndex])
    }
    
    private func add(childController: UIViewController) {
        addChildViewController(childController)
        childController.view.frame = contanerView.bounds
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contanerView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
}
