import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let lampsListController = LampsListController()
        let navVC = UINavigationController(rootViewController: lampsListController)
        navVC.navigationBar.isTranslucent = false
        
        let window = UIWindow()
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

final class LampsListController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        CSVParser().start()
    }
}

final class CSVParser {
    
    
    func loadCSV() -> String {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure()
            return ""
        }
        
        let fileName = "led.csv"
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        /// try to load from cache
        if let dataString = try? String(contentsOf: fileURL, encoding: .windowsCP1251) {
            return dataString
        }
        
        /// load from server
        /// https://habr.com/ru/company/lamptest/blog/444288/
        guard
            let url = URL(string: "http://lamptest.ru/led.csv"),
            let data = try? Data(contentsOf: url),
            let dataString = String(data: data, encoding: .windowsCP1251)
        else {
            assertionFailure()
            return ""
        }
        
        /// save to cache
        do {
            try dataString.write(to: fileURL, atomically: false, encoding: .windowsCP1251)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
        return dataString
    }
    
    func start() {

        let dataString = loadCSV()
        
        


//        var convertedString: NSString?
//        let aa = NSString.stringEncoding(for: data, encodingOptions: nil, convertedString: &convertedString, usedLossyConversion: nil)

        let csvTable = self.csv(data: dataString)

        let names = ["no", "brand", "model", "power_l", "matt", "dim", "color_l", "lm_l", "eq_l", "ra_l", "u", "pf_l", "angle_l", "life", "war", "prod", "w", "d", "h", "t", "barcode", "plant", "base", "shape", "type", "type2", "url", "shop", "rub", "usd", "p", "pf", "lm", "color", "cri", "r9", "Rf", "Rg", "Duv", "flicker", "angle", "switch", "umin", "drv", "tmax", "date", "instruments", "add2", "add3", "add4", "add5", "cqs", "eq", "rating", "act", "lamp_image", "lamp_desc"]

        print(names.joined(separator: ", "))
        print(csvTable.first!.joined(separator: ", "))
        
        guard csvTable.first == names else {
            assertionFailure()
            return
        }
        
//        let url = URL(string: "http://lamptest.ru/led.csv")!
//
//        let task = URLSession.shared.downloadTask(with: url) { fileUrl, response, error in
//            guard let fileUrl = fileUrl, let dataString = try? String(contentsOf: fileUrl, encoding: .windowsCP1251) else {
//                return
//            }
//            let q = self.csv(data: dataString)
//        }
//
////        let task = URLSession.shared.dataTask(with: url) { data, response, error in
////            guard let data = data, let dataString = String(data: data, encoding: .windowsCP1251) else {
////                return
////            }
////            let q = self.csv(data: dataString)
////        }
//
//        /// keep reference to observation
//        /// https://stackoverflow.com/a/54204979
//        if #available(iOS 11.0, *) {
//            observation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
//                print(progress.fractionCompleted)
//                if progress.isFinished {
//                    /// observation?.invalidate() will be called automatically when an NSKeyValueObservation is deinited
//                    self?.observation = nil
//                    print("finished")
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//
//        task.resume()
        

        
//        var data = readDataFromCSV(fileName: kCSVFileName, fileType: kCSVFileExtension)
//        data = cleanRows(file: data)
//        let csvRows = csv(data: data)
//        print(csvRows[1][1])
    }
    private var observation: NSKeyValueObservation?
    
    /// https://www.google.com/search?q=csv+encoding+swift&oq=csv+encoding+swift&aqs=chrome..69i57.4067j0j7&sourceid=chrome&ie=UTF-8
    /// https://stackoverflow.com/a/43295363
    func csv(data: String) -> [[String]] {
        var data = data.replacingOccurrences(of: "\r", with: "\n")
        data = data.replacingOccurrences(of: "\n\n", with: "\n")
        
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }

    func parseCSV (contentsOfURL: NSURL, encoding: String.Encoding, error: NSErrorPointer) -> [(name:String, detail:String, price: String)]? {
        var data: Data?
        assertionFailure()
        let dataString: String! = String.init(data: data!, encoding: .utf8)
        var items: [(String, String, String)] = []
        let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
        
        for line in lines {
            var values: [String] = []
            if line != "" {
                if line.range(of: "\"") != nil {
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != "" {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(",", into: &value)
                        }
                        
                        values.append(value! as String)
                        
                        if textScanner.scanLocation < textScanner.string.count {
                            textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.components(separatedBy: ",")
                }
                
                // Put the values into the tuple and add it to the items array
                let item = (values[0], values[1], values[2])
                items.append(item)
                print(item.0)
                print(item.1)
                print(item.2)
            }
        }

        
//        // Load the CSV file and parse it
//        let delimiter = ","
//        var items:[(name:String, detail:String, price: String)]?
//
//        if let content = String(contentsOfURL: contentsOfURL, encoding: encoding, error: error) {
//            items = []
//            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
//
//            for line in lines {
//                var values:[String] = []
//                if line != "" {
//                    // For a line with double quotes
//                    // we use NSScanner to perform the parsing
//                    if line.rangeOfString("\"") != nil {
//                        var textToScan:String = line
//                        var value:NSString?
//                        var textScanner:NSScanner = NSScanner(string: textToScan)
//                        while textScanner.string != "" {
//
//                            if (textScanner.string as NSString).substringToIndex(1) == "\"" {
//                                textScanner.scanLocation += 1
//                                textScanner.scanUpToString("\"", intoString: &value)
//                                textScanner.scanLocation += 1
//                            } else {
//                                textScanner.scanUpToString(delimiter, intoString: &value)
//                            }
//
//                            // Store the value into the values array
//                            values.append(value as! String)
//
//                            // Retrieve the unscanned remainder of the string
//                            if textScanner.scanLocation < count(textScanner.string) {
//                                textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
//                            } else {
//                                textToScan = ""
//                            }
//                            textScanner = NSScanner(string: textToScan)
//                        }
//
//                        // For a line without double quotes, we can simply separate the string
//                        // by using the delimiter (e.g. comma)
//                    } else  {
//                        values = line.componentsSeparatedByString(delimiter)
//                    }
//
//                    // Put the values into the tuple and add it to the items array
//                    let item = (name: values[0], detail: values[1], price: values[2])
//                    items?.append(item)
//                }
//            }
//        }
//
        return items
    }

}
