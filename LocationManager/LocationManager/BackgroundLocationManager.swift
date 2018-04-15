//
//  BackgroundLocationManager.swift
//  LocationManager
//
//  Created by Bondar Yaroslav on 2/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreLocation

final class BackgroundLocationManager: NSObject {
    
    static let shared = BackgroundLocationManager()
    
    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        configurateLocationManager()
    }
    
    private func configurateLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100 //kCLDistanceFilterNone - any changes
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                self.locationManager.startMonitoringSignificantLocationChanges()
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func stopUpdateLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }
}

extension BackgroundLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print(location)
        //        delegate?.didUpdate(location: location)
        //        didUpdate(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse) || (status == .authorizedAlways)){
            startUpdateLocation()
        }
    }
}


