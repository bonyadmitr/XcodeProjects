import Foundation

// https://habr.com/company/jugru/blog/427845/

/// See the reasoning behind the shifting of sizeof: to MemoryLayout
/// https://github.com/apple/swift-evolution/blob/9cf2685293108ea3efcbebb7ee6a8618b83d4a90/proposals/0101-standardizing-sizeof-naming.md

MemoryLayout<Bool>.size
MemoryLayout<Int>.size // 8 on 64-bit
MemoryLayout<String>.size
MemoryLayout<Double>.size

MemoryLayout<Bool?>.size // 1???
MemoryLayout<Int?>.size
MemoryLayout<String?>.size // 16???
MemoryLayout<Double?>.size


/// stride
/// the distance between successive elements in a contiguous array.
/// the same as sizeof(type) in C/Obj-C.
/// https://stackoverflow.com/a/27640066

MemoryLayout<Bool>.stride
MemoryLayout<Int>.stride
MemoryLayout<String>.stride
MemoryLayout<Double>.stride

MemoryLayout<Bool?>.stride
MemoryLayout<Int?>.stride
MemoryLayout<String?>.stride
MemoryLayout<Double?>.stride



/// есть свойство alignment, возвращающее для указанного типа соответствующее ему правило выравнивания
MemoryLayout<Bool>.alignment
MemoryLayout<Int>.alignment
MemoryLayout<String>.alignment // 8, addresses must be multiples of 8
MemoryLayout<Double>.alignment

MemoryLayout<Bool?>.alignment
MemoryLayout<Int?>.alignment
MemoryLayout<String?>.alignment
MemoryLayout<Double?>.alignment


// MARK: - struct

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


// MARK: - bytes

func bytes<T>(of value: T) -> [UInt8]{
    var value = value
    let size = MemoryLayout<T>.size
    return withUnsafePointer(to: &value, {
        $0.withMemoryRebound(to: UInt8.self,
                             capacity: size,
                             { Array(UnsafeBufferPointer(start: $0, count: size)) })
    })
}

let someString = "1"
let bytes1 = bytes(of: someString)
print(bytes1, bytes1.count)

String(bytes: bytes1, encoding: .ascii)

let data = Data(bytes: bytes1, count: bytes1.count)
String(data: data, encoding: .ascii)


/// ----

/// https://stackoverflow.com/a/40597960
func toData<T>(_ value: T) -> Data {
    var value = value
    return Data(bytes: &value, count: MemoryLayout<T>.size)
}

//for byte in toData(someString) {
//    print(String(format: "%02X", byte))
//}
let data2 = toData(someString)
String(data: data2, encoding: .ascii)

/// ----

func toByteArray<T>(_ value: T) -> [UInt8] {
    var val = value
    return Array(UnsafeRawBufferPointer(start: &val, count: MemoryLayout<T>.size))
}

let bytes2 = toByteArray(someString)
String(bytes: bytes2, encoding: .ascii)
String(bytes: bytes2, encoding: .utf8)

/// ----

let bytes3 = [UInt8](someString.utf8)
String(bytes: bytes3, encoding: .ascii)
String(bytes: bytes3, encoding: .utf8)



// MARK: - FixedWidthInteger

/// https://stackoverflow.com/a/47221437
func sizeof<T:FixedWidthInteger>(_ int:T) -> Int {
    return int.bitWidth/UInt8.bitWidth
}

func sizeof<T:FixedWidthInteger>(_ intType:T.Type) -> Int {
    return intType.bitWidth/UInt8.bitWidth
}

sizeof(UInt16.self) // 2
sizeof(20) // 8
