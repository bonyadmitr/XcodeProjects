import Foundation
import UIKit

/// https://www.youtube.com/watch?v=SDsUdAHBiZA
/// https://github.com/sanllier/ASLabel
class ASLabel: UIView {
    
    // MARK: - Public Properties
    override var intrinsicContentSize: CGSize {
        guard let compatibleBounds = compatibleBounds, let content = attributedText else { return .zero }
        
        return content.boundingRect(
            with: CGSize(width: compatibleBounds.width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
            ).size
    }
    
    override var bounds: CGRect { didSet { setNeedsDisplay() } }
    
    var attributedText: NSAttributedString? { didSet { setNeedsDisplay() } }
    
    // MARK: - Public Methods
    @objc func _needsDoubleUpdateConstraintsPass() -> Bool {
        return true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext(), let content = attributedText else { return }
        
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(bounds)
        
        let framesetter = CTFramesetterCreateWithAttributedString(content as CFAttributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, content.length), path, nil)
        CTFrameDraw(frame, ctx)
    }
    
    // MARK: - Private Properties
    private var layoutEngine: Any? {
        let objcMethodName = "nsli_layoutEngine"
        let objcSelector = Selector(objcMethodName)
        
        typealias targetCFunction = @convention(c) (AnyObject, Selector) -> Any
        let target = class_getMethodImplementation(type(of: self).self, objcSelector)
        let casted = unsafeBitCast(target, to: targetCFunction.self)
        return casted(self, objcSelector)
    }
    
    private var compatibleBounds: CGRect? {
        let objcMethodName = "_nsis_compatibleBoundsInEngine:"
        let objcSelector = Selector(objcMethodName)
        
        typealias targetCFunction = @convention(c) (AnyObject, Selector, Any) -> CGRect
        let target = class_getMethodImplementation(type(of: self).self, objcSelector)
        let casted = unsafeBitCast(target, to: targetCFunction.self)
        return layoutEngine.flatMap { casted(self, objcSelector, $0) }
    }
    
}
