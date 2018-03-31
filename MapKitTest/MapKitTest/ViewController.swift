//
//  ViewController.swift
//  MapKitTest
//
//  Created by Bondar Yaroslav on 28/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    
    lazy var searchController: MapSearchController = {
        return MapSearchController(searchResultsController: self.placesController)
    }()
    lazy var mapViewManager: MapViewManager = {
        return MapViewManager(mapView: self.mapView)
    }()
    
    let placesController = PlacesController()
    let autocompleteManager = AutocompleteManager()
    
    var pointsArray: [[CLLocationCoordinate2D]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //definesPresentationContext = true
        placesController.searchController = searchController
        placesController.delegate = self
        searchController.searchResultsUpdater = self
        
        speedLabel.layer.cornerRadius = 4
        mapViewManager.didUpdateSpeed = { speed in
            
            self.speedLabel.text = String(format: "%.1f", speed) + " KM/H"
        }
    }
    
    @IBAction func actionSearchBarButton(_ sender: UIBarButtonItem) {
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func actionGpsButton(_ sender: UIButton) {
        mapViewManager.switchTrackingMode()
    }

    @IBAction func actionRecordButton(_ sender: UIButton) {
        
        if !mapViewManager.isRecording {
            mapViewManager.startRecord()
            return
        }
        
        let points = mapViewManager.finishRecord()
        pointsArray.append(points)
        mapViewManager.buildRoutes(with: pointsArray)
        
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        autocompleteManager.startSearch(with: searchController.searchBar.text!) { response in
            self.placesController.places = response.mapItems
        }
    }
}

extension ViewController: PlacesControllerDelegate {
    func didSelect(place: MKMapItem) {
        mapViewManager.add(place: place)
    }
}
