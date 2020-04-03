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
