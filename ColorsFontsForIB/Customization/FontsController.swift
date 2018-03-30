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
}

extension FontsControllerDelegate {
    func didSelectFont(fontName: String) {}
}

// TODO: create move to selected font with checkmark
// maybe need create done - cancel nav buttons
// maybe need to change headers
// maybe need create font size selection

final class FontsController: UITableViewController {

    enum FontType {
        case all
        case regular
        case light
        case bold
    }
    
    var type = FontType.all
    
    // MARK: - Properties
    
    private lazy var familyNames: [String] = {
        return UIFont.familyNames.sorted()
    }()
    
    var fonts: [[String]] = []
    
    weak var delegate: FontsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let q = familyNames
//            .map { ($0, UIFont.fontNames(forFamilyName: $0).sorted()) }
//            .flatMap { (family, names) -> (String, String, String)? in
//                let someBold = names.first { $0.hasSuffix("-Bold") || $0.hasSuffix("-Medium") }
//                let someLight = names.first { $0.hasSuffix("-Light") }
//                let regular = names.first { $0.hasSuffix("-Regular") } ?? family
//                if let bold = someBold, let light = someLight {
//                    return (regular, bold, light)
//                } else {
//                    return nil
//                }
//            }
//            .execute { (regular, bold, light) in
//                Fonts.setNames(base: regular, light: light, bold: bold)
////                print(regular, bold, light)
////                print(UIFont(name: regular, size: 17)!)
////                print(UIFont(name: bold, size: 17)!)
////                print(UIFont(name: light, size: 17)!)
//            }
//            .count
//        print(q)
        
        
        switch type {
        case .all:
            fonts = familyNames
                .map { UIFont.fontNames(forFamilyName: $0) }
        case .regular:
            fonts = [familyNames
                .flatMap { UIFont.fontNames(forFamilyName: $0) }
                .filter { $0.contains("Regular") }]
        case .light:
            fonts = [familyNames
                .flatMap { UIFont.fontNames(forFamilyName: $0) }
                .filter { $0.contains("Light") }]
        case .bold:
            fonts = [familyNames
                .flatMap { UIFont.fontNames(forFamilyName: $0) }
                .filter { $0.contains("Bold") || $0.contains("Medium") }]
        }
    }
    
    // MARK: - Actions
    
    @IBAction func defaultBarButton(_ sender: UIBarButtonItem) {
        delegate?.didSelectFont(fontName: UIFont.systemFont(ofSize: 17).fontName)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fonts.count
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
        if numberOfSections(in: tableView) == 1 {
            return nil
        }
        return familyNames[section]
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontName = getFontName(for: indexPath)
        delegate?.didSelectFont(fontName: fontName)
        dismiss(animated: true, completion: nil)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if numberOfSections(in: tableView) == 1 {
            return nil
        }
        return familyNames.map { ($0 as NSString).substring(to: 1) }
        
    }
    
    // MARK: - Helpers
    
     private func getFontName(for indexPath: IndexPath) -> String {
        return fonts[indexPath.section][indexPath.row]
    }
}


