//
//  ViewController.swift
//  CollapseExpandSectionTableView
//
//  Created by Bondar Yaroslav on 7/30/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class SectionsDataSource {
    
//    static let shared = SectionsDataSource()
//    private init() {}
    
    struct Section {
        let title: String
        let rows: [String]
        let isExpanded: Bool
    }
    
    var sections = [
        Section(title: "UIKit",
                rows: ["UIButton и UILable",
                       "UISegmentedControl",
                       "UISlider"],
                isExpanded: false),
        Section(title: "Networking",
                rows: ["GET Requests",
                       "POST Request",
                       "JSONDecoder"],
                isExpanded: false),
        Section(title: "Notifications",
                rows: ["Local notifications",
                       "Push-Notification",
                       "Sandbox"],
                isExpanded: false)
    ]
    
}

final class SectionsDataSource2 {
    
    let sectionData = [
        ["1"],
        ["1","2"],
        ["1","2","3"],
        ["1","2","3","4"],
        ["1","2","3","4","5"],
    ]
    
    var hiddenSections = Set<Int>()
    
}

/// article https://programmingwithswift.com/expand-collapse-uitableview-section-with-swift/
class ViewController: UIViewController {
    
    //private let sectionsDataSource = SectionsDataSource()
    private let sectionsDataSource2 = SectionsDataSource2()

    private lazy var tableView: UITableView = {
        let newValue = UITableView()
        newValue.dataSource = self
        newValue.delegate = self
        newValue.frame = self.view.bounds
        newValue.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newValue.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        newValue.register(UINib(nibName: "TitleHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TitleHeaderView")
        newValue.rowHeight = 44
        newValue.sectionHeaderHeight = 60
        newValue.sectionFooterHeight = 2 /// separator
        return newValue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    private func hideSection(_ section: Int) {
        let indexPathsForSection = (0..<sectionsDataSource2.sectionData[section].count).map { IndexPath(row: $0, section: section) }
        
        tableView.beginUpdates()
        
        if sectionsDataSource2.hiddenSections.contains(section) {
            sectionsDataSource2.hiddenSections.remove(section)
            tableView.insertRows(at: indexPathsForSection, with: .fade)
        } else {
            sectionsDataSource2.hiddenSections.insert(section)
            tableView.deleteRows(at: indexPathsForSection, with: .fade)
        }
        
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsDataSource2.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsDataSource2.hiddenSections.contains(section) ? 0 : sectionsDataSource2.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.backgroundColor = .white
        cell.textLabel?.text = sectionsDataSource2.sectionData[indexPath.section][indexPath.row]
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleHeaderView") as? TitleHeaderView else {
            assertionFailure()
            return nil
        }
        view.setup(title: "Section: \(section)", section: section) { [weak self] section in
            self?.hideSection(section)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
}
