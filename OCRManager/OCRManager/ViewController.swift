//
//  ViewController.swift
//  OCRManager
//
//  Created by Bondar Yaroslav on 4/15/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let documentScanner = DocumentScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        documentScanner.open(in: self) { images in
            for image in images {
                OCRManager().scan(image: image) { ocrText in
                    print(ocrText)
                }
            }
        }
    }

}

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

import Vision

final class OCRManager {
    
    func scan(image: UIImage, handler: (String) -> Void) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        let ocrRequest = VNRecognizeTextRequest { (request, error) in
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                assertionFailure("The observations are of an unexpected type.")
                return
            }
            
            
            let numberSet = CharacterSet(charactersIn: "0123456789.,")
            let charSet = numberSet.inverted
            
            
//            let q = observations
//                .compactMap { $0.topCandidates(1).first }
//                .compactMap { $0.string }
//            print(q)
//
//            let w = observations
//                .compactMap { $0.topCandidates(1).first }
//                .flatMap { $0.string.components(separatedBy: numberSet) }
//            print(w)
            
//            "".components(separatedBy: numberSet)
            
//            print(
//                observations.compactMap ({ $0.topCandidates(1).first }).filter({ $0.string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil })
//            )
            
            let allStrings = observations
            .compactMap { $0.topCandidates(1).first }
            .compactMap { $0.string }
            
            /// https://stackoverflow.com/a/45207707/5893286
            //Scanner(string: "").scanDouble()
//            guard let scanner = Scanner.localizedScanner(with: "") as? Scanner else {
//                assertionFailure()
//                return
//            }
//            let qq = scanner.scanFloat()
            
            let ocrText: [Float] = allStrings
                .filter { $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil }
                .flatMap { $0.components(separatedBy: charSet) }
                .compactMap { Float($0) }
            
//            let ocrText: [Float] = observations
//                .compactMap { $0.topCandidates(1).first }
//                .compactMap { $0.string }
//                .filter { $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil }
//                .flatMap { $0.components(separatedBy: charSet) }
//                .compactMap { Float($0) }
            
//                .compactMap { $0.string }
//                .compactMap { ($0.string as NSString).floatValue }
//                //.compactMap { Int($0.string) }
//                .compactMap { String($0) }
//                .joined(separator: "\n")
            
            
            print(allStrings.joined(separator: "\n"))
            /// prevent 1e+07 https://stackoverflow.com/a/43746733/5893286
            print("- numbers:", ocrText.map({ String(format: "%.0f", $0) }))
            print()
            
//            var ocrText = ""
//            for observation in observations {
//
//                guard let topCandidate = observation.topCandidates(1).first else { return }
//
//                ocrText += topCandidate.string + "\n"
//            }
            
            
//            DispatchQueue.main.async {
//                self.ocrTextView.text = ocrText
//                self.scanButton.isEnabled = true
//            }
        }
        
        let recognitionLanguages: [String]
        do {
            /// at the moment (March 12, 2020) Vision framework supports only English
            /// source https://stackoverflow.com/a/60654614/5893286
            recognitionLanguages = try VNRecognizeTextRequest.supportedRecognitionLanguages(for: .accurate, revision: VNRecognizeTextRequest.currentRevision)
        } catch {
            assertionFailure(error.localizedDescription)
            recognitionLanguages = []
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = recognitionLanguages//["en-US"]
        ocrRequest.minimumTextHeight = 0.05
        ocrRequest.usesLanguageCorrection = false
        //ocrRequest.customWords = ["@gmail.com"]
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try requestHandler.perform([ocrRequest])
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
    }
    
}
