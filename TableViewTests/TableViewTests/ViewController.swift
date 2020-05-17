//
//  ViewController.swift
//  TableViewTests
//
//  Created by Bondar Yaroslav on 5/12/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

/// UILable memory cost https://www.fadel.io/blog/posts/ios-performance-tips-you-probably-didnt-know/
/// answer https://twitter.com/Inferis/status/1229872436801228801

/// willDisplayCell vs cellForRowAt  https://jobs.zalando.com/en/tech/blog/proper-use-of-cellforrowatindexpath-and-willdisplaycell

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
            newValue.prefetchDataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("- cellForRowAt: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        print("- 0", cell.textLabel!.bounds.height)
        
        cell.indexPath = indexPath
        cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.text = "Row \(indexPath.row + 1) \n\n\n\n\n\n\n---Row \(indexPath.row + 1)"
        print("- 1", cell.textLabel!.bounds.height)
        
        /// insert big tet to test UILable memory cost
//        cell.textLabel?.text = """
//        """
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("*  willDisplay: \(indexPath.row)")
        
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = "Row \(indexPath.row + 1) \n\n\n\n\n\n\n---Row \(indexPath.row + 1)"
        
        print("- 2", cell.textLabel!.bounds.height)
        
//        cell.textLabel?.text = "Row \(indexPath.row + 1)"
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = nil
    }
    
    /// called twice
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
        //print("% heightForRowAt: \(indexPath.row)")
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //print("# prefetchRowsAt: \(indexPaths.map{$0.row})")
    }
    
}

final class TableCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    override func layoutSubviews() {
        print("- 4", textLabel!.bounds.height)
        super.layoutSubviews()
        
        
        print("- 5", textLabel!.bounds.height)
        
        print("- layoutSubviews \(indexPath!.row)")
    }
    
}
