//
//  ViewController.swift
//  ViperApp-Mac
//
//  Created by Bondar Yaroslav on 02/10/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import ViperKit
import DipUI

class ListViewController: NSViewController, ModuleInputProvider {
    var output: ListViewOutput!
    var moduleInput: ModuleInput!
    
    @IBOutlet private weak var tableView: NSTableView!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewIsReady()
    }
    
    @objc private func onItemClicked() {
        print("row \(tableView.clickedRow), col \(tableView.clickedColumn) clicked")
        
        let post = posts[tableView.clickedRow]
        output.didSelect(post: post)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let configurationBlock = sender as? ConfigurationBlockHolder else {
            return
        }
        guard let controller = segue.destinationController as? ModuleInputProvider else {
            fatalError("Controller should be Module Input provider")
        }
        configurationBlock.block(controller.moduleInput)
    }
}

extension ListViewController: StoryboardInstantiatable {}


final internal class ConfigurationBlockHolder {
    typealias ConfigurationHandler = (ModuleInput) -> Void
    
    let block: ConfigurationHandler
    
    init(block: @escaping ConfigurationHandler) {
        self.block = block
    }
}
extension ListViewController: TransitionHandler {
    func openModule(segueIdentifier: String) {
        
    }
    
    func openModule(segueIdentifier: String, configurationBlock: @escaping ConfigurationBlock) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: segueIdentifier), sender: ConfigurationBlockHolder(block: configurationBlock))
//        guard let configurationBlock = sender as? ConfigurationBlockHolder else {
//            return
//        }
        
    }
    
    func closeCurrentModule() {
        
    }
}

extension ListViewController: ListViewInput {
    func setupInitialState() {
        tableView.action = #selector(onItemClicked)
    }
    
    func show(error: Error) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func update(post: Post) {
        if let i = posts.index(of: post) {
            posts[i] = post
            tableView.reloadData(forRowIndexes: IndexSet(integer: i), columnIndexes: IndexSet(integersIn: 0...3))
        }
    }
    
    func diplay(posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
}

extension ListViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return posts.count
    }
    
}

extension ListViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "titleCell"), owner: nil) as? NSTableCellView else { return nil }
        
        var text = ""
        let post = posts[row]
        
        if tableColumn == tableView.tableColumns[0] {
            text = post.title
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(post.id)
        } else if tableColumn == tableView.tableColumns[2] {
            text = String(post.userId)
        } else if tableColumn == tableView.tableColumns[3] {
            text = post.body
        }
        
        cell.textField?.stringValue = text
        return cell
    }
}

