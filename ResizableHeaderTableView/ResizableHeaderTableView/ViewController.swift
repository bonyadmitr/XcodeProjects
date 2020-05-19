//
//  ViewController.swift
//  ResizableHeaderTableView
//
//  Created by Bondar Yaroslav on 1/17/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: ResizableHeaderTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = HeaderView()
//        let label = UILabel()
//        label.backgroundColor = .red
//        label.numberOfLines = 0
        header.titleLabel.font = UIFont.systemFont(ofSize: 25)
//        header.label.font = UIFont.preferredFont(forTextStyle: .title1)
//        header.label.lineBreakMode = .byClipping
        header.titleLabel.text = "1-ResizableHeaderTableView 2-ResizableHeaderTableView 3-ResizableHeaderTableView -ResizableHeaderTableView 4-ResizableHeaderTableView 5-ResizableHeaderTableView 6-ResizableHeaderTableView 7-ResizableHeaderTableView 8-ResizableHeaderTableView 9-ResizableHeaderTableView 10-ResizableHeaderTableView 11-ResizableHeaderTableView 12-ResizableHeaderTableView\n\n 13-ResizableHeaderTableView"
        
        tableView.tableHeaderView = header
        tableView.sizeHeaderToFit()
        
        tableView.dataSource = self
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.backgroundColor = .magenta
        return cell
    }
}

final class HeaderView: UIView {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = .red
        backgroundColor = .blue
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
}
