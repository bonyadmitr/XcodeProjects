import UIKit
import MapKit.MKMapView

/// https://medium.com/@michael.eisel/quick-trick-to-make-your-app-snappier-f2413bf78318
final class ViewController: UIViewController {

    @IBOutlet private weak var presentButton: UIButton! {
        didSet {
            
            presentButton.addTarget(self, action: #selector(down), for: .touchDown)
            
            // If user generated touchDown and then didn't generate touchUpInside, we would have
            // set up a view controller that won't even be presented, which can cause problems,
            // e.g. with metrics.
            // Instead, run the .up() method for *every* possible outcome after touchDown:
            // touchUpInside, touchUpOutside, and touchCancel
            presentButton.addTarget(self, action: #selector(up), for: .touchUpInside)
            presentButton.addTarget(self, action: #selector(up), for: .touchUpOutside)
            presentButton.addTarget(self, action: #selector(up), for: .touchCancel)
            
            // Don't let the user do anything else while they're pressing the button
            presentButton.isExclusiveTouch = true
        }
    }
    
    @IBOutlet private weak var pushButton: UIButton! {
        didSet {
            
            pushButton.addTarget(self, action: #selector(down), for: .touchDown)
            
            // If user generated touchDown and then didn't generate touchUpInside, we would have
            // set up a view controller that won't even be presented, which can cause problems,
            // e.g. with metrics.
            // Instead, run the .up() method for *every* possible outcome after touchDown:
            // touchUpInside, touchUpOutside, and touchCancel
            pushButton.addTarget(self, action: #selector(upPush), for: .touchUpInside)
            pushButton.addTarget(self, action: #selector(upPush), for: .touchUpOutside)
            pushButton.addTarget(self, action: #selector(upPush), for: .touchCancel)
            
            // Don't let the user do anything else while they're pressing the button
            pushButton.isExclusiveTouch = true
        }
    }
    
    var vc: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc private func up() {
        if let vc = vc {
            present(vc, animated: true, completion: nil)
        } else {
//            assertionFailure()
            // This else block would only happen in the (probably) impossible case when .async
            // is still enqueued from .down()
        }
        vc = nil
    }
    
    @objc private func down() {
        // This .async call is necessary if the button has an animation that you want to run
        // while the main thread is blocked to set up the new VC.
        // You might think that blocking the main thread, even after the animation has just
        // begun, will still block the animation. But actually, once they've been started,
        // animations keep going even when the main thread is blocked
        DispatchQueue.main.async {
            let vc = ToOpenController()
            let _ = vc.view // Calling .view triggers viewDidLoad etc., so that more setup can occur
            self.vc = vc
        }
    }
    
    @objc private func upPush() {
        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        } else {
//            assertionFailure()
            // This else block would only happen in the (probably) impossible case when .async
            // is still enqueued from .down()
        }
        vc = nil
    }

    @IBAction private func presentController(_ sender: UIButton) {
        let vc = ToOpenController()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func pushController(_ sender: UIButton) {
        let vc = ToOpenController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

import UIKit

final class ToOpenController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "ToOpenController"
    }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    var objects = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "ToOpenController"
        view.backgroundColor = .red
        view.addSubview(closeButton)
        
        for _ in 1...500 {
            objects.append(MKMapView())
        }
        print("500 MKMapView created, about 200mb of memory")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let offset: CGFloat = 16
        closeButton.frame = CGRect(x: offset, y: offset * 2, width: view.bounds.width - offset * 2, height: 44)
    }
    
    @objc private func close() {
        if let navVC = navigationController {
            navVC.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
