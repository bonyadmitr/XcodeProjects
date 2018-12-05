import UIKit

internal typealias Scale = (dx: CGFloat, dy: CGFloat)

internal extension CIImage {
    
    /// Creates an `UIImage` with interpolation disabled and scaled given a scale property
    ///
    /// - parameter withScale:  a given scale using to resize the result image
    ///
    /// - returns: an non-interpolated UIImage
    internal func nonInterpolatedImage(with scale: Scale = Scale(dx: 1, dy: 1)) -> UIImage? {
        
        guard let cgImage = CIContext(options: nil).createCGImage(self, from: extent) else {
            assertionFailure()
            return nil
        }
        
        let size = CGSize(width: extent.size.width * scale.dx, height: extent.size.height * scale.dy)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure()
            return nil
        }
        
        context.interpolationQuality = .none
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
