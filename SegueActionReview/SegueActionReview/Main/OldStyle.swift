
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

