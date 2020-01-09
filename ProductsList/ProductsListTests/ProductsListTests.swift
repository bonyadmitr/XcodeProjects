@testable import ProductsList
import XCTest
import CoreData

extension ImageTextCell: NibInitiable {}

final class ProductsListTests: XCTestCase {
    
    typealias Item = ProductItemDB

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func test_deallocation_ProductsListController() {
        assertDeallocationPresentedVC { ProductsListController() }
    }
    
    private func test_deallocation_ProductDetailController() {
        let context = CoreDataStack.shared.viewContext
        let item = anyItem(for: context)
        
        assertDeallocationPresentedVC { ProductDetailController(item: item) }
        //assertDeallocationPresentedVC { () -> UIViewController in
        //    let vc = ProductDetailController(item: item)
        //    return vc
        //}
    }
    
    private func anyItem(for context: NSManagedObjectContext) -> Item {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        return (try? request.execute().first) ?? newItem(for: context)
    }
    
    private func newItem(for context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.id = -1
        newItem.detail = "some detail"
        newItem.name = "some name"
        newItem.originalId = "-1"
        newItem.price = -111
        /// don't save temp item
        //try? context.save()
        return newItem
    }
    
    private func test_deallocation_ProductService() {
        assertDeallocation { Product.Service() }
    }
    
    private func test_deallocation_ItemStorage() {
        assertDeallocation { Item.Storage() }
    }
    
    private func test_deallocation_Views() {
        assertDeallocation { SearchController(searchResultsController: nil) }
        assertDeallocation { TitleSupplementaryView() }
        assertDeallocation { ScaledHeightImageView(frame: .zero) }
        assertDeallocation { ImageTextCell.initFromNib() }
        
    }
    
    private func test_deallocation_CoreDataStack() {
        assertDeallocation { CoreDataStack(storeType: .sqlite, modelName: "ProductsList") }
    }
    
}
