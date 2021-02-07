//
//  ViewController.swift
//  JsonDecoding
//
//  Created by Yaroslav Bondr on 05.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
