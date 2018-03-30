//
//  FontsController.swift
//  FontSelect
//
//  Created by zdaecqze zdaecq on 28.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol FontsControllerDelegate: class {
    func didSelect(fontName: String)
}
extension FontsControllerDelegate {
    func didSelect(fontName: String) {}
}

final class FontsController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    weak var delegate: FontsControllerDelegate?

    fileprivate var fontFamiliesAll: [FontFamily] = []
    fileprivate var fontFamilies: [FontFamily] = []
    fileprivate var type = FontType.all
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontFamiliesAll = FontsManager.shared.fontFamilies(for: type)
        fontFamilies = fontFamiliesAll
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = L10n.search
        searchController.searchBar.scopeButtonTitles = [FontType.all.name,
                                                        FontType.regular.name,
                                                        FontType.light.name,
                                                        FontType.bold.name]
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func defaultBarButton(_ sender: UIBarButtonItem) {
        delegate?.didSelect(fontName: UIFont.systemFont(ofSize: 17).fontName)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    fileprivate func fontName(for indexPath: IndexPath) -> String {
        return fontFamilies[indexPath.section].fonts[indexPath.row]
    }
    
    /// To solve from console: Attempting to load the view of a view controller while it is deallocating...
    deinit {
        self.searchController.view.removeFromSuperview()
    }
}

extension FontsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if fontFamilies.notEmpty {
            tableView.backgroundView = nil
            return fontFamilies.count
        }
        let noDataLabel = UILabel()
        noDataLabel.lzText = L10n.notFound
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontFamilies[section].fonts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: FontCell.self, for: indexPath)
        cell.fill(with: fontName(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fontFamilies[section].name
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexes = fontFamilies.map { ($0.name as NSString).substring(to: 1) }
        indexes.insert(UITableViewIndexSearch, at: 0)
        return indexes
    }
    
    /// need for UITableViewIndexSearch
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if index == 0 {
            tableView.contentOffset = .zero
        }
        return index - 1
    }
}

// MARK: - UITableViewDelegate
extension FontsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        let fName = fontName(for: indexPath)
        FabricManager.shared.log(fontName: fName)
        delegate?.didSelect(fontName: fName)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension FontsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterFonts(for: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        type = FontType(rawValue: selectedScope) ?? .all
        fontFamiliesAll = FontsManager.shared.fontFamilies(for: type)
        filterFonts(for: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        type = .all
        searchBar.selectedScopeButtonIndex = type.rawValue
        fontFamiliesAll = FontsManager.shared.fontFamilies(for: type)
        filterFonts(for: "")
    }
    
    // MARK: Helpers
    
    private func filterFonts(for searchText: String) {
        if searchText.isEmpty {
            fontFamilies = fontFamiliesAll
        } else {
            fontFamilies = fontFamiliesAll.filter { $0.name.contains(searchText) }
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchControllerDelegate
extension FontsController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        FabricManager.shared.log(searchText: searchController.searchBar.text)
    }
}
