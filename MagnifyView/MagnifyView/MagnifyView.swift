import UIKit

/// normal debug warnings:
/// Unable to look up screen scale
/// Unexpected physical screen orientation
///
// TODO: frame edge cases
// TODO: create new logic to render one time and only move view
/// https://github.com/damidund/Magnifying-Glass-Effect
final class MagnifyView: UIView {
    
    var viewToMagnify: UIView?
    
    var touchPoint: CGPoint = .zero {
        didSet {
            center = CGPoint(x: touchPoint.x, y: touchPoint.y - yOffset)
            setNeedsDisplay()
        }
    }
    
    var zoom: CGFloat = 2
    var yOffset: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialInit()
    }
    
    private func initialInit() {
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure()
            return
        }
        context.translateBy(x: 1 * frame.width * 0.5, y: 1 * frame.height * 0.5)
        context.scaleBy(x: zoom, y: zoom)
        context.translateBy(x: -1 * touchPoint.x, y: -1 * touchPoint.y)
        viewToMagnify?.layer.render(in: context)
    }
}
