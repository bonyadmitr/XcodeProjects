import Foundation

enum URLs {
    
    private static let basePath = "https://s3-eu-west-1.amazonaws.com/developer-application-test"
    
    enum Products {
        private static let base = basePath + "/cart"
        
        static let all = base + "/list"
        
        static func detail(id: String) -> String {
            return base + "/\(id)/detail"
        }
    }
    
}
