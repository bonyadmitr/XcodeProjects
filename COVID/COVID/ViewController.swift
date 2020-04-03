//
//  ViewController.swift
//  COVID
//
//  Created by Bondar Yaroslav on 4/1/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum URLs {
    private static let baseUrl = URL(string: "https://corona.lmao.ninja")!
    
    static let countries = baseUrl.appendingPathComponent("countries")
    static let all = baseUrl.appendingPathComponent("all")
}


//extension Data {
//    var stringValue: String {
//        return String(data: self, encoding: .utf8) ?? String(describing: self)
//    }
//}

//extension Collection where Indices.Iterator.Element == Index {
//
//    /// article https://medium.com/flawless-app-stories/say-goodbye-to-index-out-of-range-swift-eca7c4c7b6ca
//    subscript(safe index: Index) -> Iterator.Element? {
//        return (startIndex <= index && index < endIndex) ? self[index] : nil
//    }
//}

//extension JSONDecoder {
//
//    /// JSONDecoder keypath
//    /// another solution https://github.com/dgrzeszczak/KeyedCodable/
//    /// another solution https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
//    /// another solution https://github.com/aunnnn/NestedDecodable
//    ///
//    /// code https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
//    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
//        let toplevel = try JSONSerialization.jsonObject(with: data)
//        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
//            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
//            return try decode(type, from: nestedJsonData)
//        } else {
//            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
//        }
//    }
//}


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

class CountyDetailController: UIViewController {

    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
}

class ViewController: UIViewController {
    
    private let globalInfoLabel: UILabel = {
        let label = UILabel()
        //label.textAlignment = .natural
        label.text = "Loading..."
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(globalInfoLabel)
        globalInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globalInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            globalInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            globalInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        

        
        
        globalInfo { [weak self] result in
            switch result {
            case .success(let globalInfo):
                
                let date = Date(timeIntervalSince1970: TimeInterval(globalInfo.updated / 1000))
                DispatchQueue.main.async {
                    self?.globalInfoLabel.text = """
                    Total: \(globalInfo.cases)
                    Deaths: \(globalInfo.deaths)
                    Active: \(globalInfo.active)
                    Recovered: \(globalInfo.recovered)
                    
                    Date: \(globalDateFormater.string(from: date))
                    """
                }
                
            case .failure(let error):
                print(error.description)
            }
        }
        
    }
    
    func globalInfo(handler: @escaping (Result<GlobalInfo, Error>) -> Void) {
        URLSession.shared.codableDataTask(with: URLs.all, completionHandler: handler)
    }
    
}

let globalDateFormater: DateFormatter = {
    let formater = DateFormatter()
    formater.dateStyle = .short
    formater.timeStyle = .short
    #if DEBUG
    formater.locale = Locale(identifier: "ru")
    #endif
    return formater
}()


extension URLSession {
    
    @discardableResult
    func codableDataTask<T: Codable>(with url: URL, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(T.self, from: data)
                    completionHandler(.success(object))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                assertionFailure(response.debugDescription)
                completionHandler(.failure(CustomErrors.unknown))
            }

        }
        
        task.resume()
        return task
    }
}

import Foundation

// MARK: - Country
struct Country: Codable {
    let country: String
    let countryInfo: CountryInfo
    let cases, todayCases, deaths, todayDeaths: Int
    let recovered, active, critical: Int
    let casesPerOneMillion, deathsPerOneMillion: Double?
    let updated: Int
}
extension Country: CustomStringConvertible {
    var description: String {
        let date = Date(timeIntervalSince1970: TimeInterval(updated / 1000))
        
        return """
        Name: \(country)
        Total: \(cases)
        Deaths: \(deaths)
        Active: \(active)
        Recovered: \(recovered)
        Critical: \(critical)
        
        Today Cases: \(todayCases)
        Today Deaths: \(todayDeaths)
        
        Date: \(globalDateFormater.string(from: date))
        """
    }
}

// MARK: - CountryInfo
struct CountryInfo: Codable {
    /// nil for Diamond Princess, MS Zaandam, Caribbean Netherlands
    let id: Int?
    let iso2, iso3: String?
    let lat, long: Float
    let flag: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case iso2, iso3, lat, long, flag
    }
}

struct GlobalInfo: Codable {
    let cases, deaths, recovered, updated: Int
    let active, affectedCountries: Int
}
