import UIKit
import Kingfisher
import CoreData

extension ProductsListController {
    
    struct SortOrderConfig {
        let title: String
        let sortDescriptors: [NSSortDescriptor]
        let sectionNameKeyPath: String?
        let headerSize: CGSize
        
        func fetchedResultsController() -> NSFetchedResultsController<Item> {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.sortDescriptors = sortDescriptors
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                fetchRequest.fetchBatchSize = 20
            } else {
                fetchRequest.fetchBatchSize = 10
            }
            
            //fetchRequest.shouldRefreshRefetchedObjects = false
            let context = CoreDataStack.shared.viewContext
            return NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: sectionNameKeyPath,
                                              cacheName: nil)
        }
        
        static let id = SortOrderConfig(title: L10n.createdDate,
                                        sortDescriptors: [NSSortDescriptor(key: #keyPath(Item.id), ascending: true)],
                                        sectionNameKeyPath: nil,
                                        headerSize: .zero)
        
        static let name = SortOrderConfig(title: L10n.name,
                                          sortDescriptors: [NSSortDescriptor(key: #keyPath(Item.name), ascending: true),
                                                            NSSortDescriptor(key: #keyPath(Item.id), ascending: true)],
                                          sectionNameKeyPath: #keyPath(Item.section),
                                          headerSize: CGSize(width: 0, height: 44))
        
        static let all: [SortOrderConfig] = [.id, .name]
    }
    
    final class Interactor {
        
        //weak var controller: ProductsListController?
        
        func prepareControllerToShareItem(_ item: Item, completion: @escaping (UIViewController) -> Void) {
            guard let imageUrl = item.imageUrl, let itemName = item.name else {
                assertionFailure("imageUrl and name must exist")
                return
            }
            
            var itemDescription = """
            Name: \(itemName)
            Price: \(item.price)
            """
            
            if let itemDetail = item.detail {
                itemDescription += "\nDescription: \(itemDetail)"
            }
            
            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                switch result {
                case .success(let source):
                    let vc = UIActivityViewController(activityItems: [source.image, itemDescription])
                    completion(vc)
                    
                case .failure(let error):
                    print("--- share error: \(error.debugDescription)")
                    let vc = UIActivityViewController(activityItems: [itemDescription])
                    completion(vc)
                }
            }
        }
        
    }
    
}

private extension UIActivityViewController {
    convenience init(activityItems: [Any]) {
        self.init(activityItems: activityItems, applicationActivities: nil)
    }
}
