import Foundation

// https://habr.com/company/jugru/blog/427845/

MemoryLayout<Bool>.size
MemoryLayout<Int>.size
MemoryLayout<String>.size
MemoryLayout<Double>.size

MemoryLayout<Bool?>.size
MemoryLayout<Int?>.size
MemoryLayout<String?>.size
MemoryLayout<Double?>.size

MemoryLayout<Bool>.stride
MemoryLayout<Int>.stride
MemoryLayout<String>.stride
MemoryLayout<Double>.stride

MemoryLayout<Bool?>.stride
MemoryLayout<Int?>.stride
MemoryLayout<String?>.stride
MemoryLayout<Double?>.stride

struct User {
    var age = 0
    var name = ""
    var sex = false
}

struct User2 {
    var age = 0
    var sex = false
    var name = ""
}

struct User3 {
    var age: Int? = 0
    var name: String? = ""
    var sex: Bool? = false
}

struct User4 {
    var age: Int? = 0
    var sex: Bool? = false
    var name: String? = ""
}

struct User5 {
    let age = 0
    let sex = false
    let name = ""
}

struct User6 {
    let age: Int? = 0
    let sex: Bool? = false
    let name: String? = ""
}

MemoryLayout<User>.size
MemoryLayout<User2>.size
MemoryLayout<User3>.size
MemoryLayout<User4>.size
MemoryLayout<User5>.size
MemoryLayout<User6>.size

MemoryLayout<User>.stride
MemoryLayout<User2>.stride
MemoryLayout<User3>.stride
MemoryLayout<User4>.stride
MemoryLayout<User5>.stride
MemoryLayout<User6>.stride


func bytes<T>(of value: T) -> [UInt8]{
    var value = value
    let size = MemoryLayout<T>.size
    return withUnsafePointer(to: &value, {
        $0.withMemoryRebound(
            to: UInt8.self,
            capacity: size,
            {
                Array(UnsafeBufferPointer(
                    start: $0, count: size))
        })
    })
}

//bytes(of: "")
