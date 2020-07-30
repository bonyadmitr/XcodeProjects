//
//  ViewController.swift
//  CollapseExpandSectionTableView
//
//  Created by Bondar Yaroslav on 7/30/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 60
        tableView.allowsSelection = false
        return tableView
    }()
    
    let sectionData = [
        ["1"],
        ["1","2"],
        ["1","2","3"],
        ["1","2","3","4"],
        ["1","2","3","4","5"],
    ]
    
    var hiddenSections = Set<Int>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }

    @objc private func hideSection(sender: UIButton) {
        let section = sender.tag
        let indexPathsForSection = (0..<sectionData[section].count).map { IndexPath(row: $0, section: section) }
        
        tableView.beginUpdates()
        
        if hiddenSections.contains(section) {
            hiddenSections.remove(section)
            tableView.insertRows(at: indexPathsForSection, with: .automatic)
        } else {
            hiddenSections.insert(section)
            tableView.deleteRows(at: indexPathsForSection, with: .automatic)
        }
        
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hiddenSections.contains(section) ? 0 : sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sectionData[indexPath.section][indexPath.row]
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(String(section), for: .normal)
        sectionButton.backgroundColor = .systemBlue
        sectionButton.tag = section
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)
        return sectionButton
    }

}
