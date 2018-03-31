//
//  PostsListController.swift
//  Networking
//
//  Created by Bondar Yaroslav on 10.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PromiseKit
import RealmSwift
import Alamofire

class PostsListController: UITableViewController {
    
    var posts = [PostRealm]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        for _ in 0..<1000 {
//            NetworkingService.instance.getAllPosts(
//                onSuccess: { posts in
//                    self.posts = posts
//                    self.tableView.reloadData()
//                },
//                onError: { error in
//                    print(error)
//            })
        
//        posts = try! Realm().objects(PostRealm.self).array
        
//        _ = PostRealm.provider.getAll().then { posts -> Void in
//            self.posts = posts
//            self.tableView.reloadData()
//        }
    
        _ = PostRealm.router.getAll().then { posts -> Void in
            self.posts = posts
            self.tableView.reloadData()
        }
        

        
        
//        }
        
        
        
//        let object = PostRealm()
//        object.title = "qqqqqqqqq"
//        object.id.value = 1000
//        
//        firstly {
//            PostRealm.provider.add(object)
//        }.then { _ -> Promise<[PostRealm]> in
//            PostRealm.provider.getAll()
//        }.then { (posts) -> Void in
//            self.posts = posts
//            self.tableView.reloadData()
//        }.catchAndLog()
        
//        PostRealm.getWithCache(
//            onSuccess: { posts in
//                self.posts = posts
//                self.tableView.reloadData()
//            },
//            onError: { error in
//                UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
//                print("ERROR")
//        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
}
