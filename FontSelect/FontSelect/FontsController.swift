//
//  FontsController.swift
//  FontSelect
//
//  Created by zdaecqze zdaecq on 28.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol FontsControllerDelegate: class {
    func didSelectFont(fontName: String)
    func didSelectDefaultFont(font: UIFont)
}

extension FontsControllerDelegate {
    func didSelectFont(fontName: String) {}
    func didSelectDefaultFont(font: UIFont) {}
}

// TODO: create move to selected font with checkmark
// maybe need create done - cancel nav buttons
// maybe need to change headers
// maybe need create font size selection

final class FontsController: UITableViewController {

    // MARK: - Properties
    
    private lazy var familyNames: [String] = {
        return UIFont.familyNames.sorted()
    }()
    
    lazy var fonts: [[String]] = {
        return self.familyNames.map { UIFont.fontNames(forFamilyName: $0).sorted() }
    }()
    
    weak var delegate: FontsControllerDelegate?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
    
    // MARK: - Actions
    
    @IBAction func defaultBarButton(_ sender: UIBarButtonItem) {
        delegate?.didSelectDefaultFont(font: UIFont.systemFont(ofSize: 17))
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return familyNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath)

        let fontName = getFontName(for: indexPath)
        let font = UIFont(name: fontName, size: 17)
        
        cell.textLabel?.text = fontName
        cell.textLabel?.font = font

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return familyNames[section]
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontName = getFontName(for: indexPath)
        delegate?.didSelectFont(fontName: fontName)
        dismiss(animated: true, completion: nil)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return familyNames.map { ($0 as NSString).substring(to: 1) }
    }
    
    // MARK: - Helpers
    
    func getFontName(for indexPath: IndexPath) -> String {
        return fonts[indexPath.section][indexPath.row]
    }
}


