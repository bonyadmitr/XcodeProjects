import Foundation

/// extension String .."To".. https://stackoverflow.com/a/26811354/5893286
/// BinaryInteger binaryDescription https://stackoverflow.com/a/56099749/5893286

/// swift AdvancedOperators https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html
/// &- &+ &*
/// ~|&^ << >> 0b00001110
//let initialBits: UInt8 = 0b00001111

extension String {
    
    /// source https://stackoverflow.com/a/38980231/5893286
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}

struct Char {
    //ascii
    let unicodeScalar: UnicodeScalar
    let character: Character
    let position: Int
}

extension String {
    func leftPadding(toLength: Int, withPad padCharacter: Character) -> String {
        if count > toLength {
            return self
        } else {
            return String(repeatElement(padCharacter, count: toLength - count)) + self
        }
    }
}


extension Data {
    func binaryString() -> String {
        return string(radix: 2, padTo: 8, separator: " ")
    }
    
    func string(radix: Int, padTo toLength: Int, separator: String) -> String {
        return reduce("") { (str, byte) -> String in
            str + String(byte, radix: radix)
                .leftPadding(toLength: toLength, withPad: "0")
                .appending(separator)
        }
    }
}

/// String.availableStringEncodings.map { String.localizedName(of: $0) }
/// String.localizedName(of: String.defaultCStringEncoding)
///"".canBeConverted(to: .utf8)
//        CFStringCreateWithCString(nil, "я", CFStringEncoding(CFStringEncodings.KOI8_R.rawValue))
//        CFStringGetNameOfEncoding(<#T##encoding: CFStringEncoding##CFStringEncoding#>)
//        CFStringIsEncodingAvailable(<#T##encoding: CFStringEncoding##CFStringEncoding#>)
//        CFStringGetSystemEncoding()
//        CFStringGetListOfAvailableEncodings()
//        kCFStringEncodingInvalidId

/// availableStringEncodings source https://github.com/jie-json/swift-corelibs-foundation-master/blob/9dcd02178d6516c137fc3970f87090904f334acd/Foundation/NSString.swift
/// online Binary Converter https://www.rapidtables.com/convert/number/ascii-to-binary.html

final class BinaryCoder {
    
    static let koi8rtNSEncoding: String.Encoding = {
        let koi8rtCFEncoding = CFStringEncoding(CFStringEncodings.KOI8_R.rawValue)
//        let name = CFStringGetNameOfEncoding(koi8rtCFEncoding)
//        print("koi8rtNSEncoding name: \(name ?? "" as CFString)")
        let koi8rtNSEncoding = CFStringConvertEncodingToNSStringEncoding(koi8rtCFEncoding)
        return String.Encoding(rawValue: koi8rtNSEncoding) // String.Encoding(rawValue: 2147486210)
    }()
    
    static var availableStringEncodings: [String.Encoding] {
        return String.availableStringEncodings
    }
    
    func decodeFromAll(_ encodingString: String) -> [String] {
        return Self.availableStringEncodings.compactMap { decode(encodingString, from: $0) }
    }
    
    func decode(_ decodingString: String, from encoding: String.Encoding) -> String? {
        let bytes = decodingString
            .split(by: 8)
            .compactMap { UInt8($0, radix: 2)! }
        return String(bytes: bytes, encoding: encoding)
//
//        let unicodeRange = UnicodeScalar("а").value...UnicodeScalar("я").value
//
//        let xx = unicodeRange.map({ Character(UnicodeScalar($0)!) })
//
//        let chars = unicodeRange.enumerated().map { arg -> Char in
//            let unicode = UnicodeScalar(arg.element)!
//            //let unicodePosition = Int(unicode.value) % unicodeRange.count
//            return Char(unicodeScalar: unicode, character: Character(unicode), position: arg.offset)
//        }
//
////        Data([0, 1, 1, 0, 0, 0, 0, 1].reversed())
//        let bytes = "1100001".data(using: .unicode)!
//
//
//        let q = Data([UInt8("1100001", radix: 2)!])
//
//        String(bytes: bytes, encoding: .unicode)
//        //Self.koi8rtNSEncoding.
//        print(chars)
//        //let wwww: Unicode.ASCII.CodeUnit = 8
//        //Data().sorted()
//        //Unicode.ASCII.decode()
//        //chars.map({ $0.unicodeScalar.value % 32 })
//
//        //Data(bytes: <#T##UnsafeRawPointer#>, count: <#T##Int#>)
//
//
//        //        let q = 0b00001110 00101101 00101111 00010100 00
//        //        Character("0b00001110")
//        //        let w = Character(UnicodeScalar(0b00001110))
//        //        print(q, w)
//
//        print(xx, String(xx))
//
//        print(unicodeRange.count)
//        print(unicodeRange.map({ ( Character(UnicodeScalar($0)!)  , $0 % 33) }))
//        //        for value in zz.map({$0 % 33}) {
//        //            print(value)
//        //        }
//
//        //print(q)
//        //print(q.count)
//        let w = decodingString.split(by: 8)
//        //.map({ String($0.reversed()) })
//        let e = w.map({ Int($0, radix: 2)! })
//        //.filter({ $0 <= 32})
//        //            .map({ $0 % 33 })
//        let r = e.map({ Character(UnicodeScalar($0)!) })
//        //print(w)
//        print(e, e.count)
//        print(r)
//        print("-|\n",String(r), "\n|-")
//
//        return String(r)
    }
    
    func encodeInAll(_ encodingString: String) -> [String] {
        return Self.availableStringEncodings.compactMap { encode(encodingString, in: $0) }
    }
    
    func encode(_ encodingString: String, in encoding: String.Encoding) -> String? {
        return encodingString
            .data(using: encoding, allowLossyConversion: false)?
            .binaryString()
    }
    
}
