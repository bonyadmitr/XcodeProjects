import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDropView()
        
//        let url = URL(fileURLWithPath: "/Users/yaroslav/Downloads/Металл КП-2/IMG_20200423_173459.jpg")
//        url.image()
//        url.qqq()
//        print(url.sizeOfImage)
//        print()
//
        
        
//        exit(0)
    }
    
    /// call the last to add view on the top
    private func addDropView() {
        let dropView = DropView(frame: view.bounds)
        dropView.setup(isSubview: true, fileTypes: NSImage.imageTypes) { filePaths, images in
            
            autoreleasepool {
                filePaths
                    .map { URL(fileURLWithPath: $0) }
//                    .forEach { $0.image() }
                    .forEach { $0.changeMetaDataWithCompress() }
            }
        }
        dropView.autoresizingMask = [.width, .height]
        view.addSubview(dropView)
    }
    
}


/// exif https://stackoverflow.com/a/49505537/5893286
///
/// CGImageDestination https://coderoad.ru/23892065/%D0%A1%D0%BE%D0%B7%D0%B4%D0%B0%D1%82%D1%8C-Jpeg-%D0%B8%D0%B7-NSData
/// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/ImageIOGuide/ikpg_dest/ikpg_dest.html


//NSImage is initWithCGImage:size:
//NSZeroSize is shorthand for "same size as the CGImage"

        
    }
    
//    func correctImageOrientation(cgImage: CGImage?) -> CGImage? {
//        guard let cgImage = cgImage else { return nil }
//        var orientedImage: CGImage?
//
//        let originalWidth = cgImage.width
//        let originalHeight = cgImage.height
//        let bitsPerComponent = cgImage.bitsPerComponent
//        let bytesPerRow = cgImage.bytesPerRow
//        let bitmapInfo = cgImage.bitmapInfo
//
//        guard let colorSpace = cgImage.colorSpace else { return nil }
//
//        let degreesToRotate = orienation.getDegree()
//        let mirrored = orienation.isMirror()
//
//        var width = originalWidth
//        var height = originalHeight
//
//        let radians = degreesToRotate * Double.pi / 180.0
//        let swapWidthHeight = Int(degreesToRotate / 90) % 2 != 0
//
//        if swapWidthHeight {
//            swap(&width, &height)
//        }
//
//        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
//
//        context?.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
//        if mirrored {
//            context?.scaleBy(x: -1.0, y: 1.0)
//        }
//        context?.rotate(by: CGFloat(radians))
//        if swapWidthHeight {
//            swap(&width, &height)
//        }
//        context?.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
//
//        context?.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(originalWidth), height: CGFloat(originalHeight)))
//        orientedImage = context?.makeImage()
//
//        return orientedImage
//    }
    
    // Method to get image and transform in tuple.
//    func orientImageWithTransform(_ imageOrientation: CGImageOrientation) -> (CGImage?, CGAffineTransform) {
//
//        var transform = CGAffineTransform.identity
//        if imageOrientation == .up { return (self.copy(), transform)}
//
//        let size = NSSize(width: width, height: height)
//        let newSize = [.left,.leftMirrored, .right, .rightMirrored].contains(imageOrientation)
//            ? NSSize(width: size.height, height: size.width) : size
//
//        // Guard that we have color space and core graphics context.
//        guard let colorSpace = self.colorSpace,
//            // New graphic context uses transformed width and height.
//            let ctx = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height),
//                                bitsPerComponent: self.bitsPerComponent, bytesPerRow: 0,
//                                space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//            else { return (nil, transform)}
//
//        // OK, now the actual work of constructing transform and creating new image.
//        switch imageOrientation {
//        case .down, .downMirrored:
//            transform = transform.translatedBy(x: size.width, y: size.height)
//            transform = transform.rotated(by: CGFloat.pi)
//            break
//        case .left,.leftMirrored:
//            transform = transform.translatedBy(x: size.height, y: 0)
//            transform = transform.rotated(by: CGFloat.pi/2)
//            break
//        case .right, .rightMirrored:
//             transform = transform.translatedBy(x: 0, y: size.width)
//             transform = transform.rotated(by: -CGFloat.pi/2)
//             break
//        case .up, .upMirrored:
//            break
//        }
//
//        if [.upMirrored, .downMirrored,.leftMirrored, .rightMirrored].contains(imageOrientation) {
//            transform = transform.translatedBy(x: size.width, y: 0)
//            transform = transform.scaledBy(x: -1, y: 1)
//        }
//
//        ctx.concatenate(transform)
//        // Interestingly, drawing with the original width and height?!
//        // So width and height here are pre-transform.
//        ctx.draw(self, in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
//
//        return (ctx.makeImage(), transform)
//    }


}

//import MobileCoreServices

extension String {
    var utTypeFromExtension: String? {
        let pathExtension = (self as NSString).pathExtension
        if pathExtension.isEmpty {
            return nil
        }
        
        let utType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue() as String?
        
        if utType?.hasPrefix("dyn.") == true {
            return kUTTypeData as String
        }
        return utType
    }
}
