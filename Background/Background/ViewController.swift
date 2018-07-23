//
//  ViewController.swift
//  Background
//
//  Created by Bondar Yaroslav on 7/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            /// if set "Location When In Use Usage"
            /// it will work without any LocationManager
            mapView.showsUserLocation = true
            
            /// compass not work in simulator
            /// ".follow" will not work after mapView.setCenter 
            mapView.userTrackingMode = .follow
            
            /// zoom 1
            //let viewRegion = MKCoordinateRegionMakeWithDistance(.init(), 500, 500)
            //let adjustedRegion = mapView.regionThatFits(viewRegion)
            //mapView.setRegion(adjustedRegion, animated: true)
            
            /// zoom 2
            let mapRegion = MKCoordinateRegion(center: .init(), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BackgroundLocationManager.shared.delegate = self
        BackgroundLocationManager.shared.startUpdateLocation()
    }
}

extension ViewController: LocationManagerDelegate {
    func didUpdate(location: CLLocation) {
        print(location)
    }
}
