import Foundation
import Alamofire

enum Product {
    
    struct Item: Decodable, Equatable, Hashable {
        let id: String
        let name: String
        let price: Int
        let imageUrl: URL
        
        enum CodingKeys: String, CodingKey {
            case id = "product_id"
            case name
            case price
            case imageUrl = "image"
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
    }
    
    struct DetailItem: Decodable {
        let description: String
    }
    
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

import CoreData

extension ProductItemDB {
    
    typealias Item = ProductItemDB
    
    final class Storage {
        
        func updateSaved(item: Item?, with detailedItem: Product.DetailItem) {
            guard let item = item, let context = item.managedObjectContext else {
                assertionFailure("there is no item")
                return
            }
            
            context.perform {
                item.detail = detailedItem.description
                
                do {
                    try context.save()
                } catch {
                    assertionFailure(error.debugDescription)
                }
            }
        }
    }
    
}
