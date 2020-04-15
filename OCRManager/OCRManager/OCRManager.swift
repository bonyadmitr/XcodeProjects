import UIKit
import Vision

final class OCRManager {
    
    func scanForNumbers(image: UIImage, handler: @escaping ([Float]) -> Void) {
        
        guard let cgImage = image.cgImage else {
            assertionFailure()
            handler([])
            return
        }
        
        let ocrRequest = VNRecognizeTextRequest { (request, error) in
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                assertionFailure("The observations are of an unexpected type.")
                return
            }
            
            
            let numberSet = CharacterSet(charactersIn: "0123456789.,")
            let charSet = numberSet.inverted
            
            let allStrings = observations
                .compactMap { $0.topCandidates(1).first }
                .compactMap { $0.string }
            
            /// https://stackoverflow.com/a/45207707/5893286
///Scanner(string: "").scanDouble()
//            guard let scanner = Scanner.localizedScanner(with: "") as? Scanner else {
//                assertionFailure()
//                return
//            }
//            let qq = scanner.scanFloat()
            
            let ocrText: [Float] = allStrings
                .filter { $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil }
                .flatMap { $0.components(separatedBy: charSet) }
                .compactMap { Float($0) }
                //.compactMap { ($0.string as NSString).floatValue }
            
//            let ocrText: [Float] = observations
//                .compactMap { $0.topCandidates(1).first }
//                .compactMap { $0.string }
//                .filter { $0.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil }
//                .flatMap { $0.components(separatedBy: charSet) }
//                .compactMap { Float($0) }
            
            handler(ocrText)
            
//            print(allStrings.joined(separator: "\n"))
//            /// prevent 1e+07 https://stackoverflow.com/a/43746733/5893286
//            print("- numbers:", ocrText.map({ String(format: "%.0f", $0) }))
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
    
    func scan(image: UIImage, handler: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            assertionFailure()
            handler("")
            return
        }
        
        let ocrRequest = VNRecognizeTextRequest { (request, error) in
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                assertionFailure("The observations are of an unexpected type.")
                return
            }
            
             let allStrings = observations
                       .compactMap { $0.topCandidates(1).first }
                       .compactMap { $0.string }
                       .joined(separator: "\n")
            
            handler(allStrings)
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
        ocrRequest.usesLanguageCorrection = true
        //ocrRequest.customWords = ["@gmail.com"]
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try requestHandler.perform([ocrRequest])
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
    }
    
}
