//
//  OldStyle.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 10.02.2024.
//

import UIKit


final class OldStyleTextController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let text = text else {
            assertionFailure()
            return
        }
        
        textLabel.text = text
    }
    
}


final class OldStyleTableController: UITableViewController {
    
    private let dataSource = (1...100).map { "Item \($0)" }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OldStyleTextController,
           let item = sender as? String
        {
            vc.text = item
        }
    }
    
    // MARK: - override tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = "didSelectRowAt " + dataSource[indexPath.row]
        
        // #1
        performSegue(withIdentifier: "showText", sender: item)
        
        // #2
        //let vc = storyboard?.instantiateViewController(withIdentifier: "OldStyleTextController") as! OldStyleTextController
        //vc.text = item
        //navigationController?.pushViewController(vc, animated: true)
    }
    
}



// MARK: - New Style

/*

final class OldStyleTextController: UIViewController, StoryboardInitable {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    private let text: String
    
    static func initFromStoryboard(text: String) -> Self {
        _initFromStoryboard(storyboardName: "OldStyle", identifier: "OldStyleTextController") { Self.init(coder: $0, text: text) }!
    }
    
    init?(coder: NSCoder, text: String) {
        self.text = text
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = text
    }
    
}


final class OldStyleTableController: UITableViewController {
    
    private let dataSource = (1...100).map { "Item \($0)" }
    
    @IBSegueAction private func showText(_ coder: NSCoder, text: String) -> UIViewController? {
        OldStyleTextController(coder: coder, text: text)
    }
    
    //@IBSegueAction private func showTextFromCell(_ coder: NSCoder) -> UIViewController? {
    //    let text = "showTextFromCell " + dataSource[tableView.indexPathForSelectedRow?.row ?? 0]
    //    return OldStyleTextController(coder: coder, text: text)
    //}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = "didSelectRowAt " + dataSource[indexPath.row]
        
        // #1
        performSegue(withIdentifier: "showText", sender: item)
        
        // #2
        //let vc = storyboard!.instantiateViewController(identifier: "OldStyleTextController") { OldStyleTextController(coder: $0, text: item) }
        // #3
        //let vc = OldStyleTextController.initFromStoryboard(text: item)
        
        //navigationController?.pushViewController(vc, animated: true)
    }
    
}
 
 */





// MARK: - helpers

/*

init?(coder: NSCoder, text: String) {
    self.text = text
    super.init(coder: coder)
}
 
required init?(coder: NSCoder) {
    fatalError()
}

required init?(coder: NSCoder) {
    assertionFailure("use @IBSegueAction or initFromStoryboard")
    text = "unknown"
    super.init(coder: coder)
}
 
 
 private let text: String
 
 
StoryboardInitable
 
    static func initFromStoryboard(text: String) -> Self {
        _initFromStoryboard(storyboardName: "OldStyle", identifier: "OldStyleTextController") { Self.init(coder: $0, text: text) }!
    }

*/


// MARK: - Old Style copy


/*
 
final class OldStyleTextController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let text = text else {
            assertionFailure()
            return
        }
        
        textLabel.text = text
    }
    
}


final class OldStyleTableController: UITableViewController {
    
    private let dataSource = (1...100).map { "Item \($0)" }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OldStyleTextController,
           let item = sender as? String
        {
            vc.text = item
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = "didSelectRowAt " + dataSource[indexPath.row]
        
        // #1
        performSegue(withIdentifier: "showText", sender: item)
        
        // #2
        //let vc = storyboard?.instantiateViewController(withIdentifier: "OldStyleTextController") as! OldStyleTextController
        //vc.text = item
        //navigationController?.pushViewController(vc, animated: true)
    }
    
}
 
 */
