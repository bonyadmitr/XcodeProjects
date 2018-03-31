//
//  TableViewController.swift
//  StateRestorationTest
//
//  Created by Bondar Yaroslav on 21/03/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var texts = ["qweqwe", "123123", "1q2w3e4r"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: texts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! ViewController
            let text = sender as! String
            vc.title = text
            vc.someText = text
        }
    }
    
    
    // MARK: - UIStateRestoration
//    
//    override func encodeRestorableState(with coder: NSCoder) {
//        super.encodeRestorableState(with: coder)
//        
//        // Encode the product.
////        coder.encode(product, forKey: DetailViewController.restoreProduct)
//    }
//    
//    override func decodeRestorableState(with coder: NSCoder) {
//        super.decodeRestorableState(with: coder)
//        
//        // Restore the product.
////        if let decodedProduct = coder.decodeObject(forKey: DetailViewController.restoreProduct) as? Product {
////            product = decodedProduct
////        }
////        else {
////            fatalError("A product did not exist. In your app, handle this gracefully.")
////        }
//    }
}
