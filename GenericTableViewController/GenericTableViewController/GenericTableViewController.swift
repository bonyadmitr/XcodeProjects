//
//  GenericTableViewController.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 02.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol NibCell: class { }

// TODO: Add cell separator settings

final class GenericTableViewController<Item, Cell: UITableViewCell>: UITableViewController {
    
    var items: [Item] = []
    let configure: (Cell, Item) -> ()
    var didSelect: (Item) -> () = { _ in }
    let reuseIdentifier = String(describing: Cell.self)
    
    
    init(items: [Item], configure: @escaping (Cell, Item) -> ()) {
        self.configure = configure
        super.init(style: .plain)
        self.items = items
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        registerCell()
    }
    
    func registerCell() {
        // TODO: maybe there is another way
        if Cell() is NibCell {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! Cell
        let item = items[indexPath.row]
        configure(cell, item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
    }
}
