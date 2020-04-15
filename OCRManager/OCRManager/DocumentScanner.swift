import VisionKit

final class DocumentScanner: NSObject {
    
    private var handler: (([UIImage]) -> Void)?
    
    func open(in vc: UIViewController, handler: @escaping ([UIImage]) -> Void) {
        #if targetEnvironment(simulator)
        /// crash 'NSGenericException', reason: 'Document camera is not available'
        print("- DocumentScanner is not available for simulator")
        #else
        
        self.handler = handler
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        vc.present(scanVC, animated: true)
        #endif
    }
}

extension DocumentScanner: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("- scan.title:", scan.title)
        let images = (0 ..< scan.pageCount).map { scan.imageOfPage(at: $0) }
        handler?(images)
        controller.dismiss(animated: true)
    }
    
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//        //Handle properly error
//        controller.dismiss(animated: true)
//    }
//
//    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//        controller.dismiss(animated: true)
//    }
}
