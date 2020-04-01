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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLSession.shared.dataTask(with: URLs.countries) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode([Country].self, from: data)
                print(gitData)
                print()
                
            } catch let err {
                print("Err", err)
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
