//
//  ListViewController.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 20/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipUI
import ViperKit

final class ListViewController: ViperController, StoryboardInstantiatable {
    var output: ListViewOutput!
    
    @IBOutlet private weak var tableView: UITableView!

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

// MARK: - View Input
extension ListViewController: ListViewInput {
    
    func setupInitialState() {
        
    }
    
    func show(error: Error) {
        UIAlertController(errorMessage: error.localizedDescription).show()
    }
    
    func update(post: Post) {
        if let i = posts.index(of: post) {
            posts[i] = post

            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
        //tableView.reloadData()
    }
    
    func diplay(posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didSelect(post: posts[indexPath.row])
    }
}
