import Foundation
import Alamofire

enum Product {
    
    struct Item: Decodable, Equatable, Hashable {
        let id: Int64
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
            let idString = try container.decode(String.self, forKey: .id)
             /// needs bcz we have "6_id_is_a_string"
            id = (idString as NSString).longLongValue
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
        
        func detail(id: Int64, handler: @escaping (Result<DetailItem, Error>) -> Void) {
            Session.withoutAuth
                .request(URLs.Products.detail(id: id))
                .customValidate()
                .responseObject(completion: handler)
        }
    }
    
}

import CoreData

extension ProductItemDB {
    @objc dynamic var section: String? {
        if let char = name?.first {
            return String(char)
        }
        return nil
    }

}

extension ProductItemDB {
    
    typealias Item = ProductItemDB
    
    final class Storage {
        
        func save(items newItems: [Product.Item]) {
            
            CoreDataStack.shared.performBackgroundTask { context in
                
                let newIds = newItems.map { $0.id }
                let propertyToFetch = #keyPath(Item.id)
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Item.className())
                fetchRequest.predicate = NSPredicate(format: "\(propertyToFetch) IN %@", newIds)
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.propertiesToFetch = [propertyToFetch]
                fetchRequest.includesSubentities = false
                //fetchRequest.includesPropertyValues = false
                //fetchRequest.includesPendingChanges = true
                //fetchRequest.returnsObjectsAsFaults = false
                //fetchRequest.returnsDistinctResults = true
                
                guard let existedDictIds = try? context.fetch(fetchRequest) as? [[String: Int64]] else {
                    assertionFailure("must be set 'fetchRequest.resultType = .dictionaryResultType'")
                    return
                }
                
                let existedIds = existedDictIds.compactMap { $0[propertyToFetch] }
                print("--- existed items count \(existedIds.count)")
                assert(existedIds.count == existedDictIds.count, "\(existedIds.count) != \(existedDictIds.count)")
                
                let itemsToSave = newItems.filter { !existedIds.contains($0.id) }
                print("--- items to save count \(itemsToSave.count)")
                
                guard !itemsToSave.isEmpty else {
                    print("--- there are no new items")
                    return
                }
                
                /// save new items
                for newItem in itemsToSave {
                    let item = Item(context: context)
                    item.id = newItem.id
                    item.name = newItem.name
                    item.imageUrl = newItem.imageUrl
                    item.price = Int16(newItem.price)
                }
                
                do {
                    try context.save()
                } catch {
                    assertionFailure(error.debugDescription)
                }
                
                #if DEBUG
                /// check saved items count
                CoreDataStack.shared.performBackgroundTask { context in
                    let fetchRequestCount = NSFetchRequest<NSFetchRequestResult>(entityName: Item.className())
                    fetchRequestCount.resultType = .countResultType
                    guard let savedItemsCount = (try? context.fetch(fetchRequestCount) as? [Int])?.first else {
                        assertionFailure()
                        return
                    }
                    print("--- saved items count:", savedItemsCount)
                    assert(existedIds.count + itemsToSave.count == savedItemsCount, "")
                }

                #endif
                
            }
            
        }
        
        func updateSaved(item: Item?, with detailedItem: Product.DetailItem, completion: @escaping ErrorCompletion) {
            guard let item = item, let context = item.managedObjectContext else {
                assertionFailure("there is no item")
                return
            }
            
            context.perform {
                item.detail = detailedItem.description
                
                do {
                    try context.save()
                    completion(nil)
                } catch {
                    assertionFailure(error.debugDescription)
                    completion(error)
                }
            }
        }
    }
    
}
