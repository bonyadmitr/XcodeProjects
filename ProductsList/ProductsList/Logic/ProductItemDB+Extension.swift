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
        
        func save(items newItems: [Product.Item], completion: @escaping ErrorCompletion) {
            
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
                    item.originalId = newItem.originalId
                    item.name = newItem.name
                    item.imageUrl = newItem.imageUrl
                    item.price = Int16(newItem.price)
                }
                
                do {
                    try context.save()
                    completion(nil)
                } catch {
                    assertionFailure(error.debugDescription)
                    completion(error)
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
                guard item.detail != detailedItem.description else {
                    print("nothing to update")
                    return
                }
                
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
