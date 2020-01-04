import UIKit
import Alamofire
import CoreData

final class ProductsListController: UIViewController, ErrorPresenter {
    
    typealias Model = Product
    typealias Item = ProductItemDB
    typealias Cell = ImageTextCell
    typealias SectionType = Int
    
    enum SortOrder: Int, CaseIterable {
        case id = 0
        case name
        
        var title: String {
            switch self {
            case .id:
                return "Created Date"
            case .name:
                return "Name"
            }
        }
    }
    
    weak var coordinator: MainCoordinator?
    private let service = Model.Service()
    private lazy var storage = Item.Storage()
    private let searchController = SearchController(searchResultsController: nil)
    private lazy var interactor = Interactor()
    private lazy var dataSource = DataSource(collectionView: vcView.collectionView)
    
    /// or #1 unsafe
    //private lazy var vcView = view as! View
    /// or #2 more safely
    //private lazy var vcView: View = {
    //    if let view = self.view as? View {
    //        return view
    //    } else {
    //        assertionFailure("override func loadView")
    //        return View()
    //    }
    //}()
    /// or #3
    private let vcView = View()
    
    override func loadView() {
        view = vcView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        vcView.collectionView.delegate = self
        
        setupSearchController()
        setupRefreshControll()
        fetchRemote()
    }
    
    /// https://developer.apple.com/documentation/uikit/view_controllers/displaying_searchable_content_by_using_a_search_controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search name/price/description"
        
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        searchController.searchBar.scopeButtonTitles = SortOrder.allCases.map { $0.title }
        
        searchController.setup(controller: self)
    }
    
    private func setupRefreshControll() {
        vcView.refreshData = { [weak self] refreshControl in
            print("refreshData")
            
            self?.service.all { [weak self] result in
                DispatchQueue.main.async {
                    assert(refreshControl.isRefreshing)
                    refreshControl.endRefreshing()
                    
                    switch result {
                    case .success(let items):
                        self?.handle(items: items)
                    case .failure(let error):
                        self?.showErrorAlert(for: error)
                    }
                }
            }
        }
        
    }

    private func fetchRemote() {
        vcView.activityIndicator.startAnimating()
        
        service.all { [weak self] result in
            DispatchQueue.main.async {
                self?.vcView.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let items):
                    self?.handle(items: items)
                case .failure(let error):
                    self?.showErrorAlert(for: error)
                }
            }
        }
        
        performFetch()
    }
    
    private func handle(items newItems: [Product.Item]) {
        storage.save(items: newItems) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(for: error)
                } else {
                    /// can be shown alert
                    print("success. items saved")
                }
            }
        }
        
    }
    
    private func performFetch() {
        dataSource.performFetch()
    }
    
}

extension ProductsListController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select cell at \(indexPath.item)")
        
        /// dismiss keyboard if search was used and pop back
        //searchController.searchBar.resignFirstResponder()
        
        guard let item = dataSource.dataSource.itemIdentifier(for: indexPath) else {
            assertionFailure()
            return
        }
        coordinator?.showDetail(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else {
            assertionFailure()
            return
        }
        cell.delegate = self
    }
}

extension ProductsListController: UISearchResultsUpdating {
    
    /// called on UISearchController touch.
    /// called twice on cancel. searchController.isActive == true and false on each call
    func updateSearchResults(for searchController: UISearchController) {
        
        /// searchController.isActive == searchController.searchBar.isFirstResponder in this case
        if !searchController.isActive {
            return
        }
        
        guard let searchText = searchController.searchBar.text else {
            assertionFailure("set empty string to the searchBar.text insead of nil")
            return
        }
        
        dataSource.update(with: searchText)
        performFetch()
    }
}

extension ProductsListController: UISearchBarDelegate {
    
    /// default for iOS 12
    //func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //    searchBar.resignFirstResponder()
    //}
    
    // TODO: clear code
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        guard let sortOrder = SortOrder(rawValue: selectedScope) else {
            assertionFailure()
            return
        }
        
        dataSource.update(with: sortOrder)
        performFetch()
        
        /// there a lite animation(not good for me) on first scope change.
        /// it is due to image placeholder.
        /// simple(but not good) fix:
        //vcView.performFetch()
    }
}

extension ProductsListController: ImageTextCellDelegate {
    
    func photoCell(cell: ImageTextCellDelegate.Cell, didShare item: ImageTextCellDelegate.Cell.Item) {
        vcView.activityIndicator.startAnimating()
        
        interactor.prepareControllerToShareItem(item) { [weak self] activityVC in
            self?.vcView.activityIndicator.stopAnimating()
            /// delay for close preview
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.presentIPadSafe(controller: activityVC, sourceView: cell)
            }
        }
    }
    
    func photoCellDidTapOnPreivew(previewController: UIViewController, item: ImageTextCellDelegate.Cell.Item) {
        print("open from preview: \(item.name ?? "nil")")
        navigationController?.pushViewController(previewController, animated: true)
    }
}
