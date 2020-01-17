import UIKit
import Kingfisher
import CoreData

extension ProductsListController {
    
    enum SortOrder: Int, CaseIterable {
        case id = 0
        case name
        
        var title: String {
            switch self {
            case .id:
                return L10n.createdDate
            case .name:
                return L10n.name
            }
        }
        
        var sortDescriptors: [NSSortDescriptor] {
            switch self {
            case .id:
                return [NSSortDescriptor(key: #keyPath(Item.id), ascending: true)]
                
            case .name:
                let sortDescriptor1 = NSSortDescriptor(key: #keyPath(Item.name), ascending: true)
                let sortDescriptor2 = NSSortDescriptor(key: #keyPath(Item.id), ascending: true)
                return [sortDescriptor1, sortDescriptor2]
            }
        }
        
        var sectionNameKeyPath: String? {
            switch self {
            case .id:
                return nil
            case .name:
                return #keyPath(Item.section)
            }
        }
        
        var headerSize: CGSize {
            switch self {
            case .id:
                return .zero
            case .name:
                return CGSize(width: 0, height: 44)
            }
        }
        
        var fetchedResultsController: NSFetchedResultsController<Item> {
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
