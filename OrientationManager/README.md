## OrientationManager

To force only one controller to be at landscape orientation.

Add OrientationManager to project:

	```swift
	class OrientationManager {
	
	    static let shared = OrientationManager()
	
	    /// you can set any orientation to lock
	    var orientationLock = UIInterfaceOrientationMask.portrait
	
	    /// lock orientation and force to rotate device
	    func lock(for orientation: UIInterfaceOrientationMask, rotateTo rotateOrientation: UIInterfaceOrientation) {
	        orientationLock = orientation
	        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
	    }
	}
	```

Usage:

1. Add code to AppDelegate

	```swift
	func application(_ application: UIApplication,
	                 supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
	        return OrientationManager.shared.orientationLock
	}
	```
2. Use in controller

	```swift
	class LandscapeController: UIViewController {
	
	    /// orientation for one controller
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        OrientationManager.shared.lock(for: .landscape, rotateTo: .landscapeLeft)
	    }
	
	    /// set previous state of orientation or any new one
	    override func viewWillDisappear(_ animated : Bool) {
	        super.viewWillDisappear(animated)
	        OrientationManager.shared.lock(for: .portrait, rotateTo: .portrait)
	    }
	}
	````
