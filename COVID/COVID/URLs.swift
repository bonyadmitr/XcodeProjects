import Foundation

enum URLs {
    private static let baseUrl = URL(string: "https://corona.lmao.ninja")!
    
    static let countries = baseUrl.appendingPathComponent("countries")
    static let all = baseUrl.appendingPathComponent("all")
}
