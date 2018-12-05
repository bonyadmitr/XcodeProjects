import UIKit

/// https://github.com/aschuch/QRCode
public final class QRCodeGenerator {
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    public enum ErrorCorrection: String {
        case low = "L"
        case medium = "M"
        case quartile = "Q"
        case high = "H"
    }
    
    /// Data contained in the generated QRCode
    public var data: Data?
    
    /// Foreground color of the output
    /// Defaults to black
    public var mainColor = CIColor(red: 0, green: 0, blue: 0)
    
    /// Background color of the output
    /// Defaults to white
    public var backgroundColor = CIColor(red: 1, green: 1, blue: 1)
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    /// The error correction. The default value is `.Low`.
    public var errorCorrection = ErrorCorrection.low
    
    // MARK: Init
    
    init() {}
    
    public init(mainColor: UIColor, backgroundColor: UIColor) {
        self.mainColor = mainColor.ciColor
        self.backgroundColor = backgroundColor.ciColor
    }
    
    func setup(_ data: Data?) {
        self.data = data
    }
    
    func setup(_ url: URL) {
        data = url.absoluteString.data(using: .isoLatin1)
    }
    
    func setup(_ string: String) {
        data = string.data(using: .isoLatin1)
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public func image() -> UIImage? {
        guard let ciImage = ciImage() else {
            assertionFailure()
            return nil
        }
        
        // Size
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height
        let scale = Scale(dx: widthRatio, dy: heightRatio)
        return ciImage.nonInterpolatedImage(with: scale)
    }
    
    /// The QRCode's CIImage representation
    public func ciImage() -> CIImage? {
        
        guard let data = data else {
            assertionFailure()
            return nil
        }
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            assertionFailure()
            return nil
        }
        
        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        
        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else {
            assertionFailure()
            return nil
        }
        
        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(mainColor, forKey: "inputColor0")
        colorFilter.setValue(backgroundColor, forKey: "inputColor1")
        
        return colorFilter.outputImage
    }
    
    func generateInBackground(completion: @escaping ResultHandler<UIImage>) {
        DispatchQueue.global().async { [weak self] in
            if let image = self?.image() {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: error
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            }
        }
    }
    
    //    func barcodeImage() -> UIImage? {
    //
    //        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
    //            assertionFailure()
    //            return nil
    //        }
    //
    //        filter.setValue(data, forKey: "inputMessage")
    //        let transform = CGAffineTransform(scaleX: 3, y: 3)
    //
    //        if let output = filter.outputImage?.transformed(by: transform) {
    //            return UIImage(ciImage: output)
    //        }
    //
    //        return nil
    //    }
}
