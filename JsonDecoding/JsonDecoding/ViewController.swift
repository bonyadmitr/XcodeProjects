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

// TODO: enum Decodable
/**
 enum RemoteItem2: Decodable, Hashable {
     case file(RemoteItem)
     case folder(RemoteFolder)
     
     private enum CodingKeys: String, CodingKey {
         case isFolder = "folder"
         case contentType = "content_type"
     }
     
     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         let isFolder = try container.decode(Bool.self, forKey: .isFolder)
         
         let contentType = try container.decode(String.self, forKey: .contentType)
         let types = contentType.components(separatedBy: "/")
         guard types.count == 2 else {
             assertionFailure(types.debugDescription)
             throw Errors.unknown
         }
         
         let primaryType = types[0]
         let secondaryType = types[1]
         
         let type = ItemType(rawValue: primaryType)!// ?? .unknown
         
         
         if isFolder {
             self = try .folder(.init(from: decoder))
         } else {
             self = try .file(.init(from: decoder))
         }
     }
 */

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchProducts()
        jsonChunks()
        
    }
    
    private func fetchProducts() {
        
        guard
            let productDetailsURL = Bundle.main.url(forResource: "productDetails", withExtension: "json"),
            let productsURL = Bundle.main.url(forResource: "products", withExtension: "json"),
            let productsNotGoodURL = Bundle.main.url(forResource: "productsNotGood", withExtension: "json")
        else {
            print("didn't find file")
            return
        }
        
        do {
            let productDetailsData = try Data(contentsOf: productDetailsURL)
            let productsData = try Data(contentsOf: productsURL)
            let productsNotGoodData = try Data(contentsOf: productsNotGoodURL)
            
            let productDetails: ProductDetails = try dataToJson(productDetailsData)
            let productDetailsClass: ProductDetailsClass = try dataToJson(productDetailsData)
            
            let products: [Product] = try dataToJson(productsData)
            let productsNotGood = (try dataToJson(productsNotGoodData) as [FailableDecodable<ProductCustom>]).compactMap(\.wrappedValue)
            let productsNotGoodClass = (try dataToJson(productsNotGoodData) as [FailableDecodable<ProductClass>]).compactMap(\.wrappedValue)
            
            print("""
            - success
            - good json: \(productDetails))
            - good json class: \(productDetailsClass))

            - good json: \(products.count): \(products)
            - not good json: \(productsNotGood.count): \(productsNotGood)
            - not good json class: \(productsNotGoodClass.count): \(productsNotGoodClass)
            """)
            
        } catch {
            print("""
            - failed
            - \(error)
            """)
        }
    }
    
    private func jsonChunks() {
        
        /// inspired https://stackoverflow.com/a/53888979/5893286
        func measure(block: () -> Void) {
            var results = [CFTimeInterval]()
            let count = 10
            for _ in 1...count {
                let startTime = CACurrentMediaTime()
                block()
                let endTime = CACurrentMediaTime()
                results.append(endTime - startTime)
            }
            
            print(results)
            print(results.reduce(0, { $0 + $1 }) / CFTimeInterval(count) )
        }
        
        struct Quote: Decodable {
            let text: String
            let author: String?
        }
        
        // 1643
        //[0.011267591966316104, 0.008694753982126713, 0.008589101023972034, 0.008496747817844152, 0.008271147962659597, 0.0074710240587592125, 0.007086320081725717, 0.007109537022188306, 0.0076550068333745, 0.0070984389167279005]
        //0.008173966966569423 | 0.00813282891176641
        let url = URL(string: "https://type.fit/api/quotes")!
        let data = try! Data(contentsOf: url)
        
        // #2
//        measure {
//            _ = try! JSONDecoder().decode([Quote].self, from: data)
//        }
        
        // #2 chunks parse
        //[0.015013829804956913, 0.012103984132409096, 0.01195448893122375, 0.01117734401486814, 0.010261397110298276, 0.009990822058171034, 0.009905562037602067, 0.009876755066215992, 0.01073588989675045, 0.010298894951120019]
        //0.011131896800361574 | 0.011040727607905865
        measure {
            let jsonArray = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray
            let chunkSize = 1000 // TODO: guard
            let q1 = jsonArray.subarray(with: .init(location: 0, length: chunkSize))
            let q2 = jsonArray.subarray(with: .init(location: chunkSize, length: jsonArray.count - chunkSize))
        
            let q1Data = try! JSONSerialization.data(withJSONObject: q1, options: [])
            let q2Data = try! JSONSerialization.data(withJSONObject: q2, options: [])
            _ = try! JSONDecoder().decode([Quote].self, from: q1Data) + (try! JSONDecoder().decode([Quote].self, from: q2Data))
        }

        
        print()
    }

}

private let snakeDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

private func dataToJson<T: Decodable>(_ data: Data) throws -> T {
    return try snakeDecoder.decode(T.self, from: data)
}

/// use for ` = "product_id"`
//private let decoder = JSONDecoder()
//private func defaultDataToJson<T: Decodable>(_ data: Data) throws -> T {
//    return try decoder.decode(T.self, from: data)
//}


// MARK: - Models

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

final class ProductDetailsClass: ProductClass {
    let desc: String
    
    private enum CodingKeys: String, CodingKey {
        case desc = "description"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        desc = try container.decode(String.self, forKey: .desc)
        try super.init(from: decoder)
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
