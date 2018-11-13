import Foundation

struct Model: Decodable {
    let name: String
    let id: Int
}

let response1 = "{ \"id\": 111, \"name\": \"John\"}".data(using: .utf8, allowLossyConversion: false)!
let response2 = "true".data(using: .utf8, allowLossyConversion: false)!
let response3 = "{ true }".data(using: .utf8, allowLossyConversion: false)!
let response4 = "1".data(using: .utf8, allowLossyConversion: false)!

var valueInInt = Int(truncating: NSNumber(value: true)) //Convert Bool to Int
let response5 = Data(bytes: &valueInInt, count: MemoryLayout.size(ofValue: valueInInt)) //Int to Data


for response in [response1, response2, response3, response4, response5] {
    do {
        let object = try JSONDecoder().decode(Model.self, from: response)
        print(object)
    } catch {
        if error is DecodingError {
            print("DecodingError")
        }
        print(error.localizedDescription)
    }
    print()
}

