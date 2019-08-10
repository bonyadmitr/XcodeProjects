import Foundation

final class HistoryDataSource {
    
    static let shared = HistoryDataSource()
    
    /// https://stackoverflow.com/a/48053492/5893286
    var history: [History] {
        get {
            if let storedObject: Data = UserDefaults.standard.data(forKey: "historyDataSource"),
                let storedPlayer = try? PropertyListDecoder().decode([History].self, from: storedObject) {
                return storedPlayer
            }
            return []
        }
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else {
                assertionFailure()
                return
            }
            UserDefaults.standard.set(data, forKey: "historyDataSource")
            didChanged?(newValue)
        }
    }
    
    var didChanged: (([History]) -> Void)?
}
