//
//  TableController.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 29.01.2024.
//

import UIKit

final class TableController: UITableViewController {
    
    //@IBSegueAction private func onShowTextCell(_ coder: NSCoder, sender: UITableViewCell) -> UIViewController? {
    //    let text = sender.textLabel?.text ?? "nil"
    //    return TextController(coder: coder, text: text)
    //}
    
    @IBSegueAction private func onShowText(_ coder: NSCoder, text: String) -> UIViewController? {
        TextController(coder: coder, text: text)
    }
    
    @IBSegueAction private func onSUIText(_ coder: NSCoder, sender: UITableViewCell) -> UIViewController? {
        let text = sender.textLabel?.text ?? "nil"
        return SwiftUIView(text: text).hostingController(coder: coder)
    }

    
    // MARK: - override tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Cell \(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.visibleCells
//        tableView.indexPath(for: <#T##UITableViewCell#>)
        
//        let text = "performSegue from cell \(indexPath.row + 1)"
//        performSegue(withIdentifier: "onShowText", sender: text)
    }
    
}
