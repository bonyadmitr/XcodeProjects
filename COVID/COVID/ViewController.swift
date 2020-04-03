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

enum CustomErrors: LocalizedError, DebugDescriptable {
    case decode(Error)
    case parse(Data)
    case server
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decode(let error):
            #if DEBUG
            return error.debugDescription
            #else
            return "Server error 01"
            #endif
            
        case .parse(let data):
            #if DEBUG
            let response = String(data: data, encoding: .utf8) ?? ""
            return "- Parse error data:\n\(response)"
            #else
            // TODO: localize error to user
            return "server_error"
            #endif
            
        case .server:
            return "Server error 02"
            
        case .unknown:
            return "Internal error"
        }
    }
    
}

protocol DebugDescriptable {
    var debugDescription: String { get }
}
extension DebugDescriptable where Self: Error {
    var debugDescription: String {
        return localizedDescription
    }
}

extension Error {
    var debugDescription: String {
        if let error = self as? DebugDescriptable {
            return error.debugDescription
        } else {
            return String(describing: self)
        }
    }
}

extension Error {
    
    //var isNetworkError: Bool {
    //    ///This way we fix our 11 error(segmentation fault 11), when we are trying to downcast self to URLError
    //    //        return self is URLError
    //    return (self as NSError).domain == NSURLErrorDomain
    //}
    //
    //var urlErrorCode: URLError.Code {
    //    ///This way we fix our 11 error(segmentation fault 11), when we are trying to downcast self to URLError
    //    //        guard let urlError = self as? URLError else {
    //    return URLError.Code(rawValue: (self as NSError).code)
    //}
    
    var description: String {
        //if isNetworkError {
        //    switch urlErrorCode {
        //    case .notConnectedToInternet, .networkConnectionLost:
        //        return "TextConstants.errorConnectedToNetwork"
        //    default:
        //        return "TextConstants.errorBadConnection"
        //    }
        //}
        
        
        #if DEBUG
        return debugDescription
        #else
        return localizedDescription
        #endif
    }
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

final class AppConfigurator {
    
    weak var window: UIWindow?
    
    private func setupApp() {
        #if DEBUG
        #endif
    }
    
    /// SceneDelegate Without Storyboard (short and simple) https://samwize.com/2019/08/05/setup-scenedelegate-without-storyboard/
    /// UIScene programmatic https://medium.com/@ZkHaider/apples-new-uiscene-api-a-programmatic-approach-52d05e382cf2
    @available(iOS 13.0, *)
    func setup(scene: UIScene) -> UIWindow? {
        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure()
            return nil
        }
        
        let window = UIWindow(windowScene: windowScene)
        setupApp()
        setupWindow(window)
        return window
    }
    
    func setupWindowForAppDelegate() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return nil
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            setupApp()
            setupWindow(window)
            return window
        }
    }
    
    private func setupWindow(_ window: UIWindow) {
        let countiesController = CountiesController()
        let navVC = UINavigationController(rootViewController: countiesController)
        
        let vc = ViewController()
        navVC.pushViewController(vc, animated: false)
        
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
extension AppConfigurator {
    static let shared = AppConfigurator()
}


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
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        countries { result in
//            switch result {
//            case .success(let countries):
//                print(countries)
//            case .failure(let error):
//                print(error.description)
//            }
//        }
        
        view.addSubview(globalInfoLabel)
        globalInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globalInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            globalInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            globalInfoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
        
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .short
        #if DEBUG
        formater.locale = Locale(identifier: "ru")
        #endif
        
        
        globalInfo { [weak self] result in
            switch result {
            case .success(let globalInfo):
                
                let date = Date(timeIntervalSince1970: TimeInterval(globalInfo.updated / 1000))
                DispatchQueue.main.async {
                    self?.globalInfoLabel.text = """
                    Total: \(globalInfo.cases)
                    Deaths: \(globalInfo.deaths)
                    Recovered: \(globalInfo.recovered)
                    
                    Date: \(formater.string(from: date)))
                    """
                }
                
            case .failure(let error):
                print(error.description)
            }
        }
        
    }
    
    func countries(handler: @escaping (Result<[Country], Error>) -> Void) {
        URLSession.shared.codableDataTask(with: URLs.countries, completionHandler: handler)
    }
    
    func globalInfo(handler: @escaping (Result<GlobalInfo, Error>) -> Void) {
        URLSession.shared.codableDataTask(with: URLs.all, completionHandler: handler)
    }
    
}

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
