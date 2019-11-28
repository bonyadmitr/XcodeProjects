import UIKit
import Kingfisher

extension ProductsListController {
    
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
            
            /// instead of this func  semaphore can be used or copy/past
            func shareVC(with items: [Any]) -> UIActivityViewController {
                return UIActivityViewController(activityItems: items, applicationActivities: nil)
            }
            
            
            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                switch result {
                case .success(let source):
                    let vc = shareVC(with: [source.image, itemDescription])
                    completion(vc)
                    
                case .failure(let error):
                    print("--- share error: \(error.debugDescription)")
                    let vc = shareVC(with: [itemDescription])
                    completion(vc)
                }
            }
        }
    }
    
}
