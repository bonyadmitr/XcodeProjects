//
//  AppearingTableViewCellsController.swift
//  AnimationsAll
//
//  Created by Bondar Yaroslav on 27.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

class AppearingTableViewCellsController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTableView()
    }
    
    // MARK: - Animation
    
    var currentMaxDisplayedCell = -1
    let animationDelay = 0.05
    
    func animateTableView() {
        tableView.reloadData()
        var delayCounter = 0.0
        
        for cell in tableView.visibleCells {
            animate(cell: cell, startYPosition: tableView.bounds.height, delay: delayCounter)
            delayCounter += animationDelay
        }
    }
    
    func animate(cell: UITableViewCell, startYPosition: CGFloat, delay: Double) {
        cell.transform = CGAffineTransform(translationX: 0, y: startYPosition)
        
        UIView.animate(withDuration: 2, delay: delay,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                            cell.transform = CGAffineTransform.identity
                       }, completion: nil)
    }

    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "some text \(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentMaxDisplayedCell < indexPath.row {
            animate(cell: cell, startYPosition: tableView.bounds.height, delay: animationDelay)
            currentMaxDisplayedCell = indexPath.row
        }
    }
}
