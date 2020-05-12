import UIKit

final class SearchController: UISearchController {
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        //searchController.searchBar.placeholder = "Search name/price/description"
        searchBar.autocapitalizationType = .none
        searchBar.spellCheckingType = .no
        searchBar.enablesReturnKeyAutomatically = true /// default true for searchBar
        searchBar.smartQuotesType = .no
        searchBar.smartDashesType = .no
        
        /// there is defalut zoom behavior like tabbar on extra large titles
        searchBar.textField.adjustsFontForContentSizeCategory = true
        /// removes suggestions bar above keyboard
        //searchBar.autocorrectionType = .yes /// default .no for searchBar
        
        //searchController.delegate = self
        
        /// to present content in current controller (without it didSelectItemAt will not work)
        obscuresBackgroundDuringPresentation = false
        
        /// for dynamic type
        NotificationCenter.default.addObserver(self, selector: #selector(onContentSizeChange),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
    
    private func setFont() {
        let font = UIFont.preferredFont(forTextStyle: .body)
        
        
        searchBar.textField.font = font
    }

    @objc private func onContentSizeChange() {
        setFont()
    }
    
    func setup(controller: UIViewController) {
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         
        Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        controller.definesPresentationContext = true
        
        /// to fix lauout on pop with active search
        controller.extendedLayoutIncludesOpaqueBars = true
        
        /// For iOS 11 and later, place the search bar in the navigation bar.
        controller.navigationItem.searchController = self
        
        /// Make the search bar always visible.
        controller.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}
