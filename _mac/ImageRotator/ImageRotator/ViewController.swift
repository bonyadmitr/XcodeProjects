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
