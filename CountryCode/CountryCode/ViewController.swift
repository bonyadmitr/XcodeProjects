//
//  ViewController.swift
//  CountryCode
//
//  Created by Bondar Yaroslav on 26/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// simulator iOS 13.3
/// Locale.isoRegionCodes.count == 256
/// NSLocale.availableLocaleIdentifiers.count == 930

class ViewController: UIViewController {
    
//    let languageManager = LanguageManager.shared
    var array = NSLocale.availableLocaleIdentifiers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let ident = array[indexPath.row]
//        cell.textLabel?.text = Locale.current.localizedString(forIdentifier: ident)
//        cell.textLabel?.text = NSLocale.components(fromLocaleIdentifier: ident).description
//        print(NSLocale.components(fromLocaleIdentifier: ident))
        cell.detailTextLabel?.text = Locale.isoRegionCodes[indexPath.row]
        cell.textLabel?.text = ident
        
        return cell
    }
}
