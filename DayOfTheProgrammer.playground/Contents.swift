import Foundation

let now = Date()
var nowComponents = Calendar.current.dateComponents([.day, .year], from: now)
nowComponents.day = 256

if let date = Calendar.current.date(from: nowComponents) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.locale = Locale(identifier: "ru")
    let dateString = dateFormatter.string(from: date)
    print("Day of the Programmer:", dateString)
}

// TODO:
//let w = 0xFF
//let q = 0b11111111
//print(w == q)
