import Foundation
import Alamofire

extension DataRequest {
    
    @discardableResult
    func responseObject<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    
                    /// Custom Dates https://useyourloaf.com/blog/swift-codable-with-custom-dates/
                    /// custom iso8601 https://stackoverflow.com/a/46458771/5893286
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// can be named as responseArray
    @discardableResult
    func responseObject<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let array = (try JSONDecoder().decode([FailableDecodable<T>].self, from: data)).compactMap { $0.base }
                    completion(.success(array))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// can be named as responseArray
    @discardableResult
    func responseObject<T: Decodable>(keyPath: String, completion: @escaping (Result<[T], Error>) -> Void) -> Self {
        return responseData(queue: .background) { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let array = (try JSONDecoder().decode([FailableDecodable<T>].self, from: data, keyPath: keyPath)).compactMap { $0.base }
                    completion(.success(array))
                } catch {
                    //DecodingError
                    #if DEBUG
                    Self.printAssertFor(responseData: responseData, data: data, error: error)
                    #endif
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func printAssertFor(responseData: AFDataResponse<Data>, data: Data, error: Error) {
        print("\n\n\n⚠️⚠️⚠️ failed request with:")
        print("- response:", responseData.response ?? "response nil")
        print("- data:", String(data: data, encoding: .utf8) ?? "failed data encoding")
        print("- error:", error.localizedDescription)
        //assertionFailure(error.debugDescription)
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
struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.base = try container.decode(Base.self)
        } catch {
//            assertionFailure("- \(error.localizedDescription)\n\(error)")
            self.base = nil
        }
        
    }
}
