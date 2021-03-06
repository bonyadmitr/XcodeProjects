import Foundation
import Alamofire

enum Product {
    
    // MARK: - Item
    
    struct Item: Decodable, Equatable, Hashable {
        let id: Int64
        let originalId: String
        let name: String
        let price: Int
        let imageUrl: URL
        
        enum CodingKeys: String, CodingKey {
            case id = "product_id"
            case name
            case price
            case imageUrl = "image"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            originalId = try container.decode(String.self, forKey: .id)
             /// needs bcz we have "6_id_is_a_string"
            id = (originalId as NSString).longLongValue
            name = try container.decode(String.self, forKey: .name)
            price = try container.decode(Int.self, forKey: .price)
            imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
    }
    
    // MARK: - DetailItem
    
    struct DetailItem: Decodable {
        let description: String
    }
    
    // MARK: - Service
    
    final class Service {
        func all(handler: @escaping (Result<[Item], Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.all)
                .customValidate()
                .responseObject(keyPath: "products", completion: handler)
        }
        
        func detail(id: String, handler: @escaping (Result<DetailItem, Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.detail(id: id))
                .customValidate()
                .responseObject(completion: handler)
        }
    }
    
}
