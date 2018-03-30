//
//  LanguageController.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 21/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class LanguageController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var languages: [String] = LocalizationManager.shared.availableLanguages
    var displayLanguages: [String] = LocalizationManager.shared.displayLanguages
}
extension LanguageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: LanguageCell.self, for: indexPath)
        cell.fill(with: displayLanguages[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LanguageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        FabricManager.shared.log(language: language)
        LocalizationManager.shared.set(language: language) {
            UIApplication.shared.restart()
        }
//        delegate?.didSelect(fontName: fName)
//        dismiss(animated: true, completion: nil)
    }
}
