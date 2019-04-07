import UIKit

class ViewController: UIViewController {

    private let snowEmitterLayer = Emitter.getLayerWith(cells: [Emitter.getCell2(), Emitter.getCell1()], width: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.magenta
        view.layer.addSublayer(snowEmitterLayer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        snowEmitterLayer.frame = view.bounds
        snowEmitterLayer.frame.origin.x += 100
        snowEmitterLayer.emitterSize.width = view.bounds.width
    }
}

struct Emitter {
    
    static func getCell1() -> CAEmitterCell {
        //        let cell = CAEmitterCell()
        ////        cell.contents = #imageLiteral(resourceName: "im_snowflake").mask(with: UIColor.white)?.cgImage
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
        
        /**
         contents: CGImage, используемый для показа одной снежинки (как вы помните, это одно из тех изображений, которые я создал самостоятельно);
         emissionRange: угол в радианах, определяющий конус, внутри которого будут появляться частицы (я выбрал угол PI, чтобы частицы были видны на всём экране);
         lifetime: определяет время жизни одной частицы;
         birthRate: определяет количество частиц, испускаемых каждую секунду;
         scale и scaleRange: влияет на размер частиц, где значение 1.0 — максимальный размер; интервал определяет отклонения в размерах между созданными частицами, что позволяет излучать частицы случайных размеров;
         velocity и velocityRange: влияет на скорость появления частиц; отклоняется случайно в рамках значения, указанного в velocityRange;
         spin и spinRange: влияют на скорость вращения, измеряемого в радианах в секунду, и случайное отклонение в рамках значения, указанного в spinRange;
         yAcceleration и xAcceleration: это два компонента вектора ускорения, применённого к эмиттеру.
         */
        let cell = CAEmitterCell()
        
        cell.contents = UIImage.circle(diameter: 5, color: .white).cgImage
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
    
    static func getCell2() -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        let image = UIImage.circle(diameter: 5, color: .white).blured(radius: 10)
        cell.contents = image?.cgImage
        cell.velocity = 40.0
        
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
    
    static func getLayerWith(cells: [CAEmitterCell], width: CGFloat) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        //        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = cells
        emitter.emitterSize = CGSize(width: width, height: 1)
        emitter.emitterPosition = CGPoint(x: width / 2, y: -10)
        
        /// https://habr.com/ru/company/badoo/blog/446938/
        /// определяет форму слоя. я использовал линию, что позволило снежинкам появляться вдоль всего экрана
        emitter.emitterShape = .line
        
        /// является частью CAMediaTiming-протокола и представляет собой время начала анимации слоя относительно анимаций родительского слоя
        emitter.beginTime = CACurrentMediaTime()
        
        /// также является частью CAMediaTiming-протокола и, по сути, представляет собой перемотку анимации вперёд на заданное время относительно её начала. Я указал значение в 10 секунд, что привело к тому, что в момент начала анимации снежинки уже покрывали экран целиком, и это именно то, чего мы хотели (если бы я указал значение в 0 секунд, то снежинки начали бы появляться сверху и покрыли экран целиком только спустя какое-то время)
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
