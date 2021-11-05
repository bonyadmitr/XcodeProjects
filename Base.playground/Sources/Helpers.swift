
import Foundation

public extension String {
    
    func file() throws -> Data {
        if let url = Bundle.main.url(forResource: self, withExtension: nil) {
            return try Data(contentsOf: url)
        } else {
            throw NSError(domain: "wrong file name", code: 0, userInfo: nil)
        }
    }
    
    func decodeFileJson<T: Decodable>(type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let data = try file()
        return try decoder.decode(T.self, from: data)
    }
    
    func decodeJson<T: Decodable>(type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        if let data = data(using: .utf8) {
            return try decoder.decode(T.self, from: data)
        } else {
            throw NSError(domain: "wrong data", code: 0, userInfo: nil)
        }
    }
    
}


// MARK: - JSONDecoder
public extension JSONDecoder {
    static let shared = JSONDecoder()
}

public extension JSONDecoder {
    
    /// JSONDecoder keypath
    /// another solution https://github.com/dgrzeszczak/KeyedCodable/
    /// another solution https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
    /// another solution https://github.com/aunnnn/NestedDecodable
    ///
    /// code https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}

/// source https://stackoverflow.com/a/46369152/5893286
public struct FailableDecodable<Base: Decodable> : Decodable {
    public let base: Base?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}


// MARK: - ReflectedStringConvertible
/// https://github.com/mattcomi/ReflectedStringConvertible/blob/master/ReflectedStringConvertible/ReflectedStringConvertible.swift
public protocol ReflectedStringConvertible: CustomStringConvertible { }

public extension ReflectedStringConvertible {
    
    var description: String {
        return desc
    }
    
    /// for NSObject subclasses only in `override var description : String { return desc }`
    var desc: String {
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
//extension NSObject {
//
//    /// source https://stackoverflow.com/a/46611354/5893286
//    //    func toDictionary(from classType: AnyClass) -> [String: Any] {
//    //
//    //        var propertiesCount : CUnsignedInt = 0
//    //        let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
//    //        var propertiesDictionary = [String:Any]()
//    //
//    //        for i in 0 ..< Int(propertiesCount) {
//    //            if let property = propertiesInAClass?[i],
//    //               let strKey = NSString(utf8String: property_getName(property)) as String? {
//    //                propertiesDictionary[strKey] = value(forKey: strKey)
//    //            }
//    //        }
//    //        return propertiesDictionary
//    //    }
//
//    // TODO: for UIViewCotroller and similar classes
//    /// working only with @objc properties
//    func desc() -> String {
//        let classType = Self.self //self.classForCoder
//        var propertiesCount: UInt32 = 0
//        guard let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount) else {
//            return ""
//        }
//
//        var result = NSStringFromClass(classType) + " {"
//
//        for i in 0 ..< Int(propertiesCount) {
//            let property = propertiesInAClass[i]
//
//            if let strKey = String(utf8String: property_getName(property)), strKey != "description" {
//                result += "\n\t\(strKey): \(value(forKey: strKey) ?? "nil")"
//            }
//        }
//        return result + "\n}"
//    }
//
//}
private extension Mirror {
    
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


