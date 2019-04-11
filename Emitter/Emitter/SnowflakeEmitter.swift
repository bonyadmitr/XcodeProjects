import UIKit

struct SnowflakeEmitter {
    
    static func snowflakeCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        //        cell.birthRate = 1
        //        cell.lifetime = 30
        //        cell.velocity = 25
        //        cell.velocityRange = 10
        ////        cell.emissionLongitude = 180.radians
        ////        cell.emissionRange = 45.radians
        //        cell.scale = 0.07
        //        cell.scaleRange = 0.03
        //        cell.spin = 0.8
        //        cell.spinRange = 0.3
        cell.velocity = 30.0
        cell.emissionRange = .pi
        cell.lifetime = 20.0
        cell.birthRate = 30
        cell.scale = 0.15
        cell.scaleRange = 0.6
        cell.velocityRange = 20
        cell.spin = -0.5
        cell.spinRange = 1.0
        cell.yAcceleration = 30.0
        cell.xAcceleration = 5.0
        return cell
    }
    
    static func snowflakeLayer() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        
        let snowflakeImage = UIImage.circle(diameter: 5, color: .white)
        
        let frontCell = snowflakeCell()
        frontCell.contents = snowflakeImage.cgImage
        
        let backCell = snowflakeCell()
        backCell.contents = snowflakeImage.blured(radius: 10)?.cgImage
        
        emitter.emitterCells = [frontCell, backCell]
        //emitter.emitterSize = CGSize(width: 1, height: 1)
        emitter.emitterPosition = CGPoint(x: 0, y: -10)
        
        /// https://habr.com/ru/company/badoo/blog/446938/
        emitter.emitterShape = .line
        emitter.beginTime = CACurrentMediaTime()
        emitter.timeOffset = 10.0
        return emitter
    }
}

/// https://stackoverflow.com/a/40561499/5893286
extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    
    /// https://github.com/tomsoft1/StackBluriOS
    /// https://github.com/leonardosul/Swift-Stack-Blur
    /// https://github.com/globchastyy/SwiftUIImageEffects/blob/master/Source/UIImageEffects.swift
    /// https://github.com/0xxd0/BlurEffect/blob/master/Sources/Box.swift
    func blured(radius: CGFloat) -> UIImage? {
        let context = CIContext()
        guard let filter = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent.insetBy(dx: -5, dy: -5))
            else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
