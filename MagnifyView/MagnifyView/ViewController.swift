import UIKit

final class ViewController: UIViewController {

    private lazy var magnifyView: MagnifyView = {
        /// use "MagnifyView(frame" or "frame.size" to setup size
        //magnifyView.frame.size = .init(width: 100, height: 100)
        let magnifyView = MagnifyView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        
        magnifyView.layer.borderColor = UIColor.lightGray.cgColor
        magnifyView.layer.borderWidth = 3
        magnifyView.zoom = 4.0
        magnifyView.yOffset = 60
        magnifyView.viewToMagnify = view
        return magnifyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLabel()
        addMagnifyGesture()
    }
    
    private func addMagnifyGesture() {
        /// UIPanGestureRecognizer + UITapGestureRecognizer not working for touch down event
        /// https://stackoverflow.com/a/18061848/5893286
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onMagnifyGesture))
        longPressGesture.minimumPressDuration = 0
        view.addGestureRecognizer(longPressGesture)
    }
    
    private func addLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = view.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.text = "some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test. some test."
        view.addSubview(label)
    }
    
    @objc private func onMagnifyGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: view)
        
        switch gesture.state {
        case .began:
            magnifyView.touchPoint = point
            view.window?.addSubview(magnifyView)
        case .changed:
            magnifyView.touchPoint = point
        case .ended, .cancelled, .failed:
            magnifyView.removeFromSuperview()
        default:
            assertionFailure()
            magnifyView.removeFromSuperview()
        }
    }
}

// MARK: - touches
/// can be used UIPanGestureRecognizer
//extension ViewController {
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        guard let point = touches.first?.location(in: view) else {
//            assertionFailure()
//            return
//        }
//
//        magnifyView.touchPoint = point
//        view.window?.addSubview(magnifyView)
//        //self.view.addSubview(magnifyView)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
//
//        guard let point = touches.first?.location(in: view) else {
//            assertionFailure()
//            return
//        }
//        magnifyView.touchPoint = point
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//
//        magnifyView.removeFromSuperview()
//    }
//
//    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//
//        magnifyView.removeFromSuperview()
//    }
//}
