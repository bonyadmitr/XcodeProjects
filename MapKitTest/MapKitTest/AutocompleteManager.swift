//
//  AutocompleteManager.swift
//  MapKitTest
//
//  Created by Bondar Yaroslav on 29/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import MapKit

class AutocompleteManager {
    
    let localSearchRequest = MKLocalSearchRequest()
    var region: MKCoordinateRegion {
        get {
            return localSearchRequest.region
        }
        set {
            localSearchRequest.region = newValue
        }
    }
    
    func startSearch(with searchText: String, complition: @escaping (MKLocalSearchResponse) -> Void) {
        localSearchRequest.naturalLanguageQuery = searchText
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.start { (response, error) -> Void in
            
            guard let response = response else {
                return print(error!.localizedDescription)
            }
            
            complition(response)
            
//            var region = response.boundingRegion
//            print(region.span.latitudeDelta)
//            region.span.latitudeDelta += 4.0
//            region.span.longitudeDelta += 0.2
//            self.mapView.setRegion(region, animated: true)


//            self.mapView.removeAnnotations(self.mapView.annotations)
//            for item in response.mapItems {
//                self.mapView.addAnnotation(item.placemark)
//            }
        }
    }
    
}
