//
//  ViewController.swift
//  JsonDecoding
//
//  Created by Yaroslav Bondr on 05.02.2021.
//

import UIKit



// TODO: json stream
/**
 https://github.com/tris-code/json + InputByteStream https://github.com/tris-code/stream/blob/master/Sources/Stream/Library/ByteStream.swift
 old https://github.com/dhoerl/SAX-JSON-Parser-ForStreamingData
 Alamofire stream https://stackoverflow.com/a/60451335/5893286
 Big Json https://type.fit/api/quotes
 
 
 https://balajahe.github.io/swift_vs_rust/
 https://gist.github.com/ivan-ushakov/ee8257e5bb3e8c872f2f07c712e76972
 try lib https://github.com/Joannis/IkigaJSON
 
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
struct ProductDetails: Decodable {
    let productId: String
    let name: String
    let price: Int
    let image: String
    let description: String
}

struct Product: Decodable {
    let productId: String
    let name: String
    let price: Int
    let image: String
}

struct ProductCustom: Decodable {
    let productId: String
    let name: String
    let price: Convertible<Int>
    let image: String
}

class ProductClass: Decodable, ReflectedStringConvertible {
    let productId: String
    let name: String
    let price: Int
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case productId
        case name
        case price
        case image
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productId = try container.decode(String.self, forKey: .productId)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        price = try container.decodeTypeOrStringAsType(Int.self, forKey: .price)
    }
}
    }





/// article https://habr.com/ru/post/501140/
/// different solutions https://stackoverflow.com/a/46369152/5893286

struct Convertible<Value: Decodable & LosslessStringConvertible>: Decodable {
    let wrappedValue: Value
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard
            let stringValue = try? container.decode(String.self),
            let value = Value(stringValue)
        else {
            wrappedValue = try container.decode(Value.self)
            return
        }
        wrappedValue = value
    }
}

struct StringConvertible: Decodable {
    let wrappedValue: String
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let number = try? container.decode(Double.self) else {
            wrappedValue = try container.decode(String.self)
            return
        }
        wrappedValue = "\(number)"
    }
}

/// the same
/// usage `let products = throwables.compactMap { try? $0.result.get() }`
//struct Throwable<T: Decodable>: Decodable {
//    let result: Result<T, Error>
//
//    init(from decoder: Decoder) throws {
//        result = Result(catching: { try T(from: decoder) })
//    }
//}
struct FailableDecodable<Value : Decodable> : Decodable {
    let wrappedValue: Value?

    init(from decoder: Decoder) throws {
        /// new
        wrappedValue = try? Value(from: decoder)
        /// old
        //let container = try decoder.singleValueContainer()
        //self.wrappedValue = try? container.decode(Value.self)
    }
}

struct FailableDecodableArray<Value : Decodable> : Decodable {
    let wrappedValue: [Value]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var elements = [Value]()
        if let count = container.count {
            elements.reserveCapacity(count)
        }

        while !container.isAtEnd {
            if let element = try? container.decode(Value.self) {
                elements.append(element)
            }
        }

        wrappedValue = elements
    }
}




extension KeyedDecodingContainer {
    
    func decodeTypeOrStringAsType<T: Decodable & LosslessStringConvertible>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch {
            return try decodeStringAsType(type, forKey: key)
        }
    }
    
    func decodeTypeOrStringAsTypeIfPresent<T: Decodable & LosslessStringConvertible>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch {
            return try decodeStringAsType(type, forKey: key)
        }
    }
    
    func decodeStringAsType<T: LosslessStringConvertible>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
        let string = try decode(String.self, forKey: key)
        if let value = T(string) {
            return value
        } else {
            throw DecodingError.dataCorruptedError(forKey: key,
                                                   in: self,
                                                   debugDescription: "\(type) cannot be inited from '\(string)'")
        }
    }
    
    // TODO: check/create for array https://github.com/IdleHandsApps/SafeDecoder/blob/master/Sources/KeyedDecodingContainerProtocol%2BSafe.swift
    
    
    func decodeTypeAsString<T: Decodable & LosslessStringConvertible>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        do {
            let value = try decode(T.self, forKey: key)
            return String(value)
        } catch {
            return try decodeStringAsType(String.self, forKey: key)
        }
    }
}


extension JSONDecoder {
    
    /// JSONDecoder keypath
    /// another solution https://github.com/dgrzeszczak/KeyedCodable/
    /// another solution https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
    /// another solution https://github.com/aunnnn/NestedDecodable
    ///
    /// code https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data) as AnyObject
        if let nestedJson = toplevel.value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}



/// https://github.com/mattcomi/ReflectedStringConvertible/blob/master/ReflectedStringConvertible/ReflectedStringConvertible.swift
protocol ReflectedStringConvertible : CustomStringConvertible { }

extension ReflectedStringConvertible {
    
    var description: String {
        let mirror = Mirror(reflecting: self)
        
        let descriptions: [String] = mirror.allChildren.compactMap { (label: String?, value: Any) in
            if let label = label {
                var value = value
                if value is String {
                    value = "\"\(value)\""
                }
                return "\(label): \(value)"
            }
            
            return nil
        }
        
        return "\(mirror.subjectType)(\(descriptions.joined(separator: ", ")))"
    }
    
}

extension Mirror {
    
    /// The children of the mirror and its superclasses.
    var allChildren: [Mirror.Child] {
        var children = [Mirror.Child]()// = Array(self.children)
        
        var superclassMirror = self.superclassMirror
        
        while let mirror = superclassMirror {
            children.append(contentsOf: mirror.children)
            superclassMirror = mirror.superclassMirror
        }
        /// to display parant class properties first
        children.append(contentsOf: self.children)
        
        return children
    }
    
}
