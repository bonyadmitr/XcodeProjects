//
//  ViewController.swift
//  GooglePlaces
//
//  Created by zdaecqze zdaecq on 11.06.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import GoogleMaps

// MARK: ViewController -
class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var mapView: GMSMapView!
    
    let placesController = PlacesController()
    var searchController : UISearchController!
    

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesController.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        //searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //searchController.searchBar.searchBarStyle = .Minimal
    }

    
    // MARK: Actions
    @IBAction func actionSearchBarButton(sender: UIBarButtonItem) {
        presentViewController(searchController, animated: true, completion: nil)
    }
    
}


// MARK: - PlacesControllerDelegate
extension ViewController: PlacesControllerDelegate {
    
    func didSelectPrediction(prediction: GMSAutocompletePrediction) {
        let placeID = prediction.placeID!
        
        GMSPlacesClient.sharedClient().lookUpPlaceID(placeID) {[weak self] (place, error) in
            
            self?.mapView.clear()
            
            guard let coordidates = place?.coordinate else {return}
            
            let marker = GMSMarker(position: coordidates)
            marker.map = self?.mapView
            
            let camera = GMSCameraPosition.cameraWithTarget(coordidates, zoom: 10)
            self?.mapView.camera = camera
            
            //dispatch_async(dispatch_get_main_queue()) { () -> Void in }
        }
    }
}


// MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        placeAutocomplete(searchText)
    }
    
    func placeAutocomplete(searchText: String) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.Address
        GMSPlacesClient.sharedClient().autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { [weak self] (results, error: NSError?) -> Void in
            
            if let results = results {
                self?.placesController.searchController = self?.searchController
                self?.placesController.placesArray = results
                self?.placesController.tableView.reloadData()
            }
        })
    }
}

