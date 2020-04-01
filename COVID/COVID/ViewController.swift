//
//  ViewController.swift
//  COVID
//
//  Created by Bondar Yaroslav on 4/1/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

enum URLs {
    static let countries = URL(string: "https://corona.lmao.ninja/countries")!
}

enum CustomErrors: LocalizedError {
    case decode(Error)
    case parse(Data)
    case server
    //case unknown
    
    var errorDescription: String? {
        switch self {
        case .decode(let error):
            #if DEBUG
            return error.localizedDescription
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
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func countries(handler: @escaping (Result<[Country], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: URLs.countries) { data, response, error in
            if let error = error {
                handler(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let objects = try decoder.decode([Country].self, from: data)
                    handler(.success(objects))
                    //                print(objects)
                    //                print()
                    
                } catch {
                    handler(.failure(error))
                }
            } else {
                
            }

        }.resume()
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
