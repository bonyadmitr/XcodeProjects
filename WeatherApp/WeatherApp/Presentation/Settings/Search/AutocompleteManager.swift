//
//  AutocompleteManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 06/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import GooglePlaces
import MapKit

public final class AutocompleteManager {
    
    func startSearch(with searchText: String, completion: @escaping ([Place]) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        
        GMSPlacesClient.shared().autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, _) in
            guard let results = results else {
                return completion([])
            }
            
            completion(results.map { Place(city: $0.attributedPrimaryText.string,
                                           country: $0.attributedSecondaryText?.string ?? "",
                                           full: $0.attributedFullText)
            })
        }
    }
}

//    "<MKMapItem: 0x841ee590> {\n    isCurrentLocation = 0;\n 
// name = \"Mail Boxes Etc.\";\n    phoneNumber = \"\\U200e+7 (861) 244-01-30\";\n 
// placemark = \"Mail Boxes Etc., ulitsa Babushkina, 215, Russia, Krasnodarskiy kray, gorodskoy okrug Gorod
//Krasnodar, Krasnodar @ <+45.04910300,+38.96015800> +/- 0.00m, region CLCircularRegion
//(identifier:'<+45.04910300,+38.96015800> radius 14147.27', center:<+45.04910300,+38.96015800>, radius:14147.27m)\";\n}"

private final class AutocompleteManager2 {
    
    let localSearchRequest = MKLocalSearchRequest()
    
    lazy var localSearch: MKLocalSearch = {
        MKLocalSearch(request: self.localSearchRequest)
    }()
    
    func startSearch(with searchText: String, completion: @escaping ([MKMapItem]) -> Void) {
        localSearchRequest.naturalLanguageQuery = searchText
        
        localSearch.start { (response, _) -> Void in
            guard let response = response else {
                return completion([])
            }
            completion(response.mapItems)
        }
    }
}
