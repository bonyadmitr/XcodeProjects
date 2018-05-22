/// Usage
//let image = UIImage(named: "myImage")
//DispatchQueue.global(qos: .userInitiated).async {
//    let blurredImage = image.blur()
//    DispatchQueue.main.async {
//        self.myImageView.image = blurredImage
//    }
//}
extension UIImage {
    /// Applies a gaussian blur to the image.
    ///
    /// - Parameter radius: Blur radius.
    /// - Returns: A blurred image.
    func blur(radius: CGFloat = 6.0) -> UIImage? {
        let context = CIContext()
        guard let inputImage = CIImage(image: self) else { return nil }
        
        guard let clampFilter = CIFilter(name: "CIAffineClamp") else { return nil }
        clampFilter.setDefaults()
        clampFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        blurFilter.setDefaults()
        blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let blurredImage = blurFilter.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgImage = context.createCGImage(blurredImage, from: inputImage.extent) else { return nil }
        
        let resultImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        return resultImage
    }
}

