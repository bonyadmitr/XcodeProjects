import UIKit

/// https://stackoverflow.com/a/42866766
final class TransparentGradientView: UIView {
    
    private let gradientMask = CAGradientLayer()
    
    /// animated
    var style = TransparentGradientStyle.vertical {
        didSet {
            setupStyle()
        }
    }
    
    enum TransparentGradientStyle {
        case vertical
        case horizontal
    }
    
    init(style: TransparentGradientStyle, mainColor: UIColor) {
        /// will not call didSet
        self.style = style
        
        self.init()
        backgroundColor = mainColor
    }
    
    /// setup backgroundColor to change color of gradient
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// setup backgroundColor to change color of gradient
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setupStyle() {
        switch style {
        case .vertical:
            gradientMask.startPoint = CGPoint(x: 0, y: 0)
            gradientMask.endPoint = CGPoint(x: 0, y: 1)
            
        case .horizontal:
            gradientMask.startPoint = CGPoint(x: 0, y: 0)
            gradientMask.endPoint = CGPoint(x: 1, y: 0)
        }
    }
    
    private func setup() {
        setupStyle()
        
        let anyNotClearColor = UIColor.white
        gradientMask.colors = [UIColor.clear.cgColor, anyNotClearColor, anyNotClearColor.cgColor]
        
        /// 0 - 0.1 is 10% of view will be UIColor.clear
        gradientMask.locations = [NSNumber(value: 0), NSNumber(value: 0.1), NSNumber(value: 1)]
        layer.mask = gradientMask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientMask.frame = bounds
    }
}

final class SegmentedController: UIViewController {
    
    private let topView = UIView()
    private let contanerView = UIView()
    let transparentGradientView = TransparentGradientView(style: .vertical, mainColor: .white)
    
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
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let edgeOffset: CGFloat = 35
        segmentedControl.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: edgeOffset).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -edgeOffset).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        contanerView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        contanerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contanerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contanerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        NSLayoutConstraint.activate([
//            contanerView.topAnchor.constraint(equalTo: topView.bottomAnchor),
//            contanerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            contanerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            contanerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])
        
        segmentedControl.addTarget(self, action: #selector(controllerDidChange), for: .valueChanged)
        
        view.addSubview(transparentGradientView)
        let transparentGradientViewHeight: CGFloat = 100
        transparentGradientView.translatesAutoresizingMaskIntoConstraints = false
        transparentGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        transparentGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        transparentGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        transparentGradientView.heightAnchor.constraint(equalToConstant: transparentGradientViewHeight).isActive = true
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
