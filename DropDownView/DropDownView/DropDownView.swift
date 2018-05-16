//
//  DropDownView.swift
//  DropDownView
//
//  Created by Bondar Yaroslav on 19/11/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class DropDownView: UIView {
    
    var options = [DropOption]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView = UITableView()
    private lazy var cellIdentifier = String(describing: UITableViewCell.self)
    
    var contentHeight: CGFloat {
        return tableView.contentSize.height
    }
    
    weak var delegate: DropDownProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isOpaque = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.separatorInset = .zero
        tableView.separatorColor = .clear
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        
//        tableView.backgroundColor = UIColor.darkGray
        
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}
extension DropDownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
//        cell.backgroundColor = UIColor.darkGray
        return cell
    }
}
extension DropDownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.dropDownView(self, didSelect: options[indexPath.row], at: indexPath.row)
    }
}
