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


        
    }
    
}

