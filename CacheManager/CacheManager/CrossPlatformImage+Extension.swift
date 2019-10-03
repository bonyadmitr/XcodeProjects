import UIKit
import AVFoundation

extension CrossPlatformImage {
    
    /// https://github.com/filestack/filestack-ios/blob/master/Filestack/Extensions/UIImage%2BHEIC.swift
    @available(iOS 11.0, *)
    func heicRepresentation(quality: Float) -> Data? {
        let destinationData = NSMutableData()
        
        if let destination = CGImageDestinationCreateWithData(destinationData, AVFileType.heic as CFString, 1, nil),
            let cgImage = cgImage
        {
            let options = [kCGImageDestinationLossyCompressionQuality: quality]
            CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
            CGImageDestinationFinalize(destination)
            
            return destinationData as Data
        }
        
        return nil
    }
}


// MARK: - Image Representation
extension CrossPlatformImage {
    /// Returns PNG representation of `base` image.
    ///
    /// - Returns: PNG data of image.
    public func pngRepresentation() -> Data? {
        #if os(macOS)
            guard let cgImage = cgImage else {
                return nil
            }
            let rep = NSBitmapImageRep(cgImage: cgImage)
            return rep.representation(using: .png, properties: [:])
        #else
            #if swift(>=4.2)
            return pngData()
            #else
            return UIImagePNGRepresentation(base)
            #endif
        #endif
    }

    /// Returns JPEG representation of `base` image.
    ///
    /// - Parameter compressionQuality: The compression quality when converting image to JPEG data.
    /// - Returns: JPEG data of image.
    public func jpegRepresentation(compressionQuality: CGFloat) -> Data? {
        #if os(macOS)
            guard let cgImage = cgImage else {
                return nil
            }
            let rep = NSBitmapImageRep(cgImage: cgImage)
            return rep.representation(using:.jpeg, properties: [.compressionFactor: compressionQuality])
        #else
            #if swift(>=4.2)
            return jpegData(compressionQuality: compressionQuality)
            #else
            return UIImageJPEGRepresentation(base, compressionQuality)
            #endif
        #endif
    }

    /// Returns a data representation for `base` image, with the `format` as the format indicator.
    ///
    /// - Parameter format: The format in which the output data should be. If `unknown`, the `base` image will be
    ///                     converted in the PNG representation.
    /// - Returns: The output data representing.
    public func data(format: ImageFormat) -> Data? {
        return autoreleasepool { () -> Data? in
            let data: Data?
            
            switch format {
            case .png:
                data = pngRepresentation()
            case .jpg:
                data = jpegRepresentation(compressionQuality: 1.0)
            case .heic:
                data = heicRepresentation(quality: 1.0)
            case .unknown:
                data = normalized.pngRepresentation()
            }
            
            return data
        }
    }
    
    public var normalized: CrossPlatformImage {
        
        // prevent animated image (GIF) lose it's images
        guard images == nil else {
            if let copy = copy() as? CrossPlatformImage {
                return copy
            } else {
                assertionFailure()
                return CrossPlatformImage()
            }
        }
        
        // No need to do anything if already up
        guard imageOrientation != .up else {
            if let copy = copy() as? CrossPlatformImage {
                return copy
            } else {
                assertionFailure()
                return CrossPlatformImage()
            }
        }
        
        return draw(to: size, inverting: true, refImage: CrossPlatformImage()) {
            fixOrientation(in: $0)
        }
    }
    
    func fixOrientation(in context: CGContext) {

        var transform = CGAffineTransform.identity

        let orientation = imageOrientation

        switch orientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: .pi / -2.0)
        case .up, .upMirrored:
            break
        #if compiler(>=5)
        @unknown default:
            assertionFailure()
            break
        #endif
        }

        //Flip image one more time if needed to, this is to prevent flipped image
        switch orientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        #if compiler(>=5)
        @unknown default:
            assertionFailure()
            break
        #endif
        }

        context.concatenate(transform)
        
        guard let cgImage = cgImage else {
            assertionFailure()
            return
        }
        
        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}

extension CrossPlatformImage {
    
    func beginContext(size: CGSize, scale: CGFloat, inverting: Bool = false) -> CGContext? {
        #if os(macOS)
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: cgImage?.bitsPerComponent ?? 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0) else
        {
            assertionFailure("[Kingfisher] Image representation cannot be created.")
            return nil
        }
        rep.size = size
        NSGraphicsContext.saveGraphicsState()
        guard let context = NSGraphicsContext(bitmapImageRep: rep) else {
            assertionFailure("[Kingfisher] Image context cannot be created.")
            return nil
        }
        
        NSGraphicsContext.current = context
        return context.cgContext
        #else
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        if inverting { // If drawing a CGImage, we need to make context flipped.
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0, y: -size.height)
        }
        return context
        #endif
    }
    
    func endContext() {
        #if os(macOS)
        NSGraphicsContext.restoreGraphicsState()
        #else
        UIGraphicsEndImageContext()
        #endif
    }
    
    func draw(to size: CGSize, inverting: Bool = false, scale: CGFloat? = nil, refImage: CrossPlatformImage? = nil, draw: (CGContext) -> Void) -> CrossPlatformImage {
        let targetScale = scale ?? self.scale
        guard let context = beginContext(size: size, scale: targetScale, inverting: inverting) else {
            assertionFailure("[Kingfisher] Failed to create CG context for blurring image.")
            return self
        }
        defer { endContext() }
        draw(context)
        guard let cgImage = context.makeImage() else {
            return self
        }
        return Self.image(cgImage: cgImage, scale: targetScale, refImage: refImage ?? self)
    }
    
    #if os(macOS)
    func fixedForRetinaPixel(cgImage: CGImage, to size: CGSize) -> CrossPlatformImage {
        
        let image = CrossPlatformImage(cgImage: cgImage, size: base.size)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        return draw(to: self.size) { context in
            image.draw(in: rect, from: .zero, operation: .copy, fraction: 1.0)
        }
    }
    #endif
    
    static func image(cgImage: CGImage, scale: CGFloat, refImage: CrossPlatformImage?) -> CrossPlatformImage {
        return CrossPlatformImage(cgImage: cgImage, scale: scale, orientation: refImage?.imageOrientation ?? .up)
    }
}
