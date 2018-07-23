//
//  BackgroundLocationManager.swift
//  BackgroundLocationManager
//
//  Created by Bondar Yaroslav on 2/17/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreLocation

/// --- Permisions ---

//<string>Your location will be used for background ...</string>

/// ???
//<key>NSLocationUsageDescription</key>
//<string>Usage</string>

/// for always usage in iOS 9
//<key>NSLocationAlwaysUsageDescription</key>
//<string>AlwaysUsage</string>

/// for always usage in iOS 11 
//<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
//<string>AlwaysAndWhenInUseUsage</string>
//<key>NSLocationWhenInUseUsageDescription</key>
//<string>WhenInUseUsage</string>

protocol LocationManagerDelegate: class {
    func didUpdate(location: CLLocation)
}
extension LocationManagerDelegate {
    func didUpdate(location: CLLocation) {}
}

//Apps can expect a notification as soon as the device moves 500 meters or more from its previous notification. It should not expect notifications more frequently than once every five minutes. If the device is able to retrieve data from the network, the location manager is much more likely to deliver notifications in a timely manner
final class BackgroundLocationManager: NSObject {
    
    static let shared = BackgroundLocationManager()
    
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    private override init() {
        super.init()
        configurateLocationManager()
    }
    
    private func configurateLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        locationManager.distanceFilter = 100 //kCLDistanceFilterNone - any changes
        locationManager.pausesLocationUpdatesAutomatically = false
        
        /// need to add: Capabilities - UIBackgroundModes - Location updates
        /// receive location updates when suspended
        locationManager.allowsBackgroundLocationUpdates = true
        
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                self.locationManager.startMonitoringSignificantLocationChanges()
//                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func stopUpdateLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
//        locationManager.stopUpdatingLocation()
    }
}

extension BackgroundLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        delegate?.didUpdate(location: location)
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


