//
//  ViewController.swift
//  InjectionTest
//
//  Created by Bondar Yaroslav on 10/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var someView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        someView.backgroundColor = UIColor.green
//        someView.layer.cornerRadius = 30
//        someView.layer.borderWidth = 10
//        someView.layer.borderColor = UIColor.red.cgColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
//        cell.layer.borderWidth = 3
//        cell.layer.borderColor = UIColor.magenta.cgColor
        return cell
    }
}

