import UIKit

final class MainApplication: UIApplication {
    override init() {
        super.init()
        
    }
}

//if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
//    print("version is : \(version)")
//}

//let bundle = Bundle.main
let bundle = Bundle(identifier: "com.by.InfoPlistSecure")!

func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = bundle.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
}

var dict = getInfoDictionary()!
dict["CFBundleShortVersionString"] = "1.1.1" as AnyObject
dict["CFBundleName"] = "from_main" as AnyObject


let filepath = bundle.path(forResource: "info", ofType: "plist")

let customPlistURL = bundle.url(forResource: "Info", withExtension: "plist")!
print(customPlistURL.absoluteString)
//let dic:[String:Any] = ["key":"val"]

do  {
    let data = try PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: .zero)
    try data.write(to: customPlistURL, options: .atomic)
    print("Successfully write")
}catch (let err){
    print(err.localizedDescription)
}

print(Bundle.main.unload())
print(Bundle.main.load())

//Bundle.main = Bundle(path: "")
if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
    print("version is : \(version)")
}

//print(getInfoDictionary()!)

//let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//let customPlistURL = docsBaseURL.appendingPathComponent("info.plist")
//print(customPlistURL.absoluteString)
//let dic:[String:Any] = ["key":"val"]
//// Swift Dictionary To Data.
//do  {
//    let data = try PropertyListSerialization.data(fromPropertyList: dic, format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
//    do {
//        try data.write(to: customPlistURL, options: .atomic)
//        print("Successfully write")
//    }catch (let err){
//        print(err.localizedDescription)
//    }
//}catch (let err){
//    print(err.localizedDescription)
//}


/// remove @UIApplicationMain in AppDelegate
_ = UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(MainApplication.self),
    NSStringFromClass(AppDelegate.self)
)


