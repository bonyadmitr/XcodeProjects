import UIKit

final class CountiesController: UIViewController {
    typealias Cell = UITableViewCell
    private let cellId = String(describing: Cell.self)
    
    private lazy var tableView: UITableView = {
        let newValue: UITableView
        if #available(iOS 13.0, *) {
            newValue = UITableView(frame: view.bounds, style: .insetGrouped)
        } else {
            newValue = UITableView(frame: view.bounds, style: .plain)
        }
        
        newValue.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        newValue.dataSource = self
        newValue.delegate = self
        //        let nib = UINib(nibName: cellId, bundle: nil)
        //        newValue.register(nib, forCellReuseIdentifier: cellId)
        newValue.register(Cell.self, forCellReuseIdentifier: cellId)
        return newValue
    }()
    
    private var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Counties"
        view.addSubview(tableView)
        
        countries { [weak self] result in
            switch result {
            case .success(let countries):
                self?.countries = countries
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.description)
            }
        }
        
    }
    
    // TODO: service
    func countries(handler: @escaping (Result<[Country], Error>) -> Void) {
        //var components = URLComponents(url: URLs.countries, resolvingAgainstBaseURL: false)!
        //components.queryItems = [URLQueryItem(name: "sort", value: "country")]
        URLSession.shared.codableDataTask(with: URLs.countries, completionHandler: handler)
    }
}

extension CountiesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].country
        return cell
    }
}

extension CountiesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CountyDetailController()
        vc.textLabel.text = countries[indexPath.row].description
        navigationController?.pushViewController(vc, animated: true)
    }
}

enum Utils {
    
    /// ISO2 (two-letter) country code
    /// source https://stackoverflow.com/a/47327408/5893286
    static func emojiFlag(from countryCode: String) -> String {
        /// 0x1F1E6 - "A".unicodeScalars.first!.value == 127397 == UnicodeScalar("🇦").value - UnicodeScalar("A").value
        return String(String.UnicodeScalarView(
            countryCode
                .uppercased()
                .unicodeScalars
                .compactMap { UnicodeScalar(127397 + $0.value) }
        ))
    }

}
