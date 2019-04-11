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
    }
}

final class CSVParser {
    
    
    func start() {
        //http://lamptest.ru/led.csv
        
//        var data = readDataFromCSV(fileName: kCSVFileName, fileType: kCSVFileExtension)
//        data = cleanRows(file: data)
//        let csvRows = csv(data: data)
//        print(csvRows[1][1])
    }
    
    /// https://stackoverflow.com/a/43295363
    func csv(data: String) -> [[String]] {
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
//        return items
    }

}
