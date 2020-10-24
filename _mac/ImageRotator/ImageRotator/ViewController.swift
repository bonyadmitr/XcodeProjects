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

    /// rotate a NSImage https://stackoverflow.com/q/31699235/5893286
    // TODO: compress
    /// https://nshipster.com/image-resizing/
    /// https://medium.com/@zippicoder/downsampling-images-for-better-memory-consumption-and-uicollectionview-performance-35e0b4526425
    /// https://gist.github.com/douglashill/607578575d249dc1e6db
    
    // TODO: why CGImageDestinationSetProperties need?
    /// calling CGImageDestinationSetProperties before CGImageDestinationAddImage solves the problem on iOS10
    //CGImageDestinationSetProperties(destination, options)
    //image destination must have at least one image
    
    // TODO: update destination, not recreate it
    func changeMetaData() {
        let destinationURL = self as CFURL
        
        guard
            let imageSource = CGImageSourceCreateWithURL(destinationURL, nil),
            let type = CGImageSourceGetType(imageSource),
            let destination = CGImageDestinationCreateWithURL(destinationURL, type, 1, nil)
        else {
            return
        }
        
        /// CGImageProperties https://developer.apple.com/documentation/imageio/cgimageproperties
        /// not working
        //kCGImagePropertyOrientation: CGImagePropertyOrientation.right.rawValue
        /// https://github.com/search?l=Swift&q=kCGImageDestinationDateTime&type=Code
        //kCGImageDestinationDateTime: Date(timeIntervalSince1970: 0)
        let options = [kCGImageDestinationOrientation: CGImagePropertyOrientation.right.rawValue] as CFDictionary
        
        /// apple example https://developer.apple.com/library/archive/qa/qa1895/_index.html
        /// swift https://gist.github.com/osteslag/085b1265fb3c6a23b60c318b15922185
        /// CFErrorCopyDescription
        /// console doc: One of kCGImageDestinationMetadata, kCGImageDestinationOrientation, or kCGImageDestinationDateTime is required
        /// CGImageDestinationFinalize doesn't need
        print(
            "saved:", CGImageDestinationCopyImageSource(destination, imageSource, options, nil)
        )
    }
    
    func changeMetaDataWithCompress() {
        let destinationURL = self as CFURL
        
        guard
            let imageSource = CGImageSourceCreateWithURL(destinationURL, nil),
            let type = CGImageSourceGetType(imageSource),
            let destination = CGImageDestinationCreateWithURL(destinationURL, type, 1, nil)
        else { return }
        
        /// kCGImageDestinationOrientation not working with CGImageDestinationAddImageFromSource
        let options = [kCGImagePropertyOrientation: CGImagePropertyOrientation.right.rawValue] as CFDictionary
        
        CGImageDestinationAddImageFromSource(destination, imageSource, 0, options)
        print(
            "saved:", CGImageDestinationFinalize(destination)
        )
    }
    
    
    func image() {//} -> UIImage? {
        
//        let context: CGContext
//        let width: CGFloat
//        let height: CGFloat
        
        guard
            let imageSource = CGImageSourceCreateWithURL(self as CFURL, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as NSDictionary?,
            let orientation = CGImagePropertyOrientation(rawValue: properties[kCGImagePropertyOrientation] as? UInt32 ?? 1),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else { return }
        
        
//        NSImage(cgImage: <#T##CGImage#>, size: <#T##NSSize#>)
        guard orientation != .right else {
            return //UIImage(cgImage: image)
        }
        
        return
        
        if image.height > image.width {
            return
        }
        
        
        
        guard let context = CGContext(data: nil,
                                      width: image.height,
                                      height: image.width,
                                      bitsPerComponent: image.bitsPerComponent,
                                      bytesPerRow: image.bytesPerRow,
                                      space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                      bitmapInfo: image.bitmapInfo.rawValue)
        else {
            return
        }
        
        let width = CGFloat(image.height)
        let height = CGFloat(image.width)
        
        var transform = CGAffineTransform.identity
        
        
        switch orientation {
        
        /// right
        case .down:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            
//            transform = transform.translatedBy(x: 0, y: height)
//            transform = transform.rotated(by: CGFloat.pi / -2.0)
            
            
          /// left
        case .up:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            
        default:
//            assertionFailure()
            return
        }
        
        
        
        context.concatenate(transform)

        // OK, now the actual work of constructing transform and creating new image.
//        switch orientation {
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
        
        
        
        let drawRect = CGRect(x: 0, y: 0, width: height, height: width)
        
        context.draw(image, in: drawRect)
        
//        do {

            
            
            
            
            
    //        let imageOrientation = UIImage.Orientation(orientation)
//
//            let bytesPerRow: Int
//            switch orientation {
//            case .left, .leftMirrored, .right, .rightMirrored:
//                width = CGFloat(image.height)
//                height = CGFloat(image.width)
//                bytesPerRow = ((Int(width)+15)/16) * 16 * (image.bitsPerPixel/8)
//            default:
//                width = CGFloat(image.width)
//                height = CGFloat(image.height)
//                bytesPerRow = image.bytesPerRow
//            }
//
//            guard let _context = CGContext(data: nil,
//                                           width: Int(width),
//                                           height: Int(height),
//                                           bitsPerComponent: image.bitsPerComponent,
//                                           bytesPerRow: bytesPerRow,
//                                           space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
//                                           bitmapInfo: image.bitmapInfo.rawValue)
//            else { return }
//            context = _context
//
//            let drawRect: CGRect
//            var transform: CGAffineTransform = CGAffineTransform.identity
//
//            switch orientation {
//            case .down, .downMirrored:
//                transform = transform.translatedBy(x: width, y: height)
//                transform = transform.rotated(by: CGFloat.pi)
//            case .left, .leftMirrored:
//                transform = transform.translatedBy(x: width, y: 0)
//                transform = transform.rotated(by: CGFloat.pi / 2.0)
//            case .right, .rightMirrored:
//                transform = transform.translatedBy(x: 0, y: height)
//                transform = transform.rotated(by: CGFloat.pi / -2.0)
//            case .up, .upMirrored:
//                break
//            @unknown default:
//                break
//            }
//
//            // Flip image one more time if needed to, this is to prevent flipped image
//            switch orientation {
//            case .upMirrored, .downMirrored:
//                transform = transform.translatedBy(x: width, y: 0)
//                transform = transform.scaledBy(x: -1, y: 1)
//            case .leftMirrored, .rightMirrored:
//                transform = transform.translatedBy(x: height, y: 0)
//                transform = transform.scaledBy(x: -1, y: 1)
//            case .up, .down, .left, .right:
//                break
//            @unknown default:
//                break
//            }
//
//            context.concatenate(transform)
//
//            switch orientation {
//            case .left, .leftMirrored, .right, .rightMirrored:
//                drawRect = CGRect(x: 0, y: 0, width: height, height: width)
//            default:
//                drawRect = CGRect(x: 0, y: 0, width: width, height: height)
//            }
//
//            context.draw(image, in: drawRect)
            // image released
//        }

        guard let newImage = context.makeImage() else { return }
        
        /// https://stackoverflow.com/a/40371604/5893286
        @discardableResult func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
//            let type = destinationURL.lastPathComponent.utTypeFromExtension! as CFString// ?? kUTTypeJPEG
            let type = CGImageSourceGetType(imageSource) ?? kUTTypeJPEG
            
            guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, type, 1, nil) else { return false }
            
            /// exif create https://github.com/smilesm2/CGImageMetadata/blob/master/func.swift
            let metadata = CGImageSourceCopyMetadataAtIndex(imageSource, 0, nil)
            CGImageDestinationAddImageAndMetadata(destination, image, metadata, nil)
            
//            CGImageDestinationAddImage(destination, image, nil)
            return CGImageDestinationFinalize(destination)
        }
        
        print("saved: \(writeCGImage(newImage, to: self))")
//        newImage

    //    let uiImage = UIImage(cgImage: newImage, scale: 1, orientation: .up)
    //    return uiImage
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
