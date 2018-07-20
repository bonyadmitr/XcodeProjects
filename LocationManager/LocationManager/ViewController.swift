//
//  ViewController.swift
//  LocationManager
//
//  Created by Bondar Yaroslav on 2/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        BackgroundLocationManager.shared.startUpdateLocation()
        
        /// zoom 1
//        let viewRegion = MKCoordinateRegionMakeWithDistance(.init(), 500, 500)
//        let adjustedRegion = mapView.regionThatFits(viewRegion)
//        mapView.setRegion(adjustedRegion, animated: true)
        
        /// zoom 2
        let mapRegion = MKCoordinateRegion(center: .init(), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mapRegion, animated: true)
        
        LocationManager.shared.start()
        
        LocationManager.shared.didUpdate = { [weak self] location in
            self?.mapView.setCenter(location.coordinate, animated: true)
            print(location)
        }
    }
}

