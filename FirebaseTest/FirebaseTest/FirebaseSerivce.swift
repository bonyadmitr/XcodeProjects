import FirebaseCore

final class FirebaseSerivce {
    
    func configureFirebase() {
        let fileName: String
        //        #if DEBUG
        //        fileName = "GoogleService-Info-debug"
        //        #else
        fileName = "GoogleService-Info"
        //        #endif
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            assertionFailure("threre is no file: \(fileName) or problem with FirebaseOptions")
            FirebaseApp.configure()
        }
    }
}
