import UIKit

final class ProductDetailController: UIViewController, ErrorPresenter {
    
    typealias Model = Product
    typealias Item = ProductItemDB
    typealias View = ProductDetailView
    
    private let service = Model.Service()
    private lazy var storage = Item.Storage()
    
    private lazy var vcView: View = {
        if let view = self.view as? View {
            return view
        } else {
            assertionFailure("setup view in IB")
            return View()
        }
    }()
    
    private let item: Item
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init from code only")
        self.item = Item()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(for: item)
    }
    
    private func setup(for item: Item) {
        title = item.name
        vcView.setup(for: item)
        loadDetail(for: item)
    }
    
    private func loadDetail(for item: Item) {
        guard let id = item.originalId else {
            assertionFailure()
            showErrorAlert(with: "Something went wrong with server")
            return
        }
        
        service.detail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailedItem):
                    self?.handle(detailedItem: detailedItem)
                    
                case .failure(let error):
                    self?.showErrorAlert(for: error)
                }
            }
        }
    }
    
    private func handle(detailedItem: Product.DetailItem) {
        vcView.setupDetail(from: detailedItem)
        
        storage.updateSaved(item: item, with: detailedItem) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(for: error)
                } else {
                    // can be shown alert
                    print("success. item updated")
                }
            }
        }
    }
    
}
