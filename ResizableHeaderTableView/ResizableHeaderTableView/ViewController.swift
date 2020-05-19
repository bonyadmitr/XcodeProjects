import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: ResizableHeaderTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = HeaderView()
        header.titleLabel.font = UIFont.systemFont(ofSize: 25)
        header.titleLabel.text = "1-ResizableHeaderTableView 2-ResizableHeaderTableView 3-ResizableHeaderTableView -ResizableHeaderTableView 4-ResizableHeaderTableView 5-ResizableHeaderTableView 6-ResizableHeaderTableView 7-ResizableHeaderTableView 8-ResizableHeaderTableView 9-ResizableHeaderTableView 10-ResizableHeaderTableView 11-ResizableHeaderTableView 12-ResizableHeaderTableView\n\n 13-ResizableHeaderTableView"
        
        tableView.tableHeaderView = header
        tableView.sizeHeaderToFit()
        tableView.dataSource = self
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.backgroundColor = .magenta
        return cell
    }
    
}
