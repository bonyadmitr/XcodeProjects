//
//  LocationManager.swift
//  TodayExtensionTest
//
//  Created by Bondar Yaroslav on 09/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import CoreLocation

protocol LocationManagerDelegate: class {
    func didUpdate(location: CLLocation)
}
extension LocationManagerDelegate {
    func didUpdate(location: CLLocation) {}
}


class LocationManager: NSObject {
    
    static private var _shared: LocationManager!
    static var shared: LocationManager {
        get {
            if _shared == nil {
                _shared = LocationManager()
                return _shared
            }
            return _shared
        }
        set {
            _shared = newValue
        }
    }
    
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationManagerDelegate?
    var didUpdate: (_ location: CLLocation) -> Void = {_ in}
    
    override init() {
        super.init()
        
        /// Privacy - Location When In Use Usage Description
        /// Privacy - Location Usage Description
        
//        <key>NSLocationWhenInUseUsageDescription</key>
//        <string>In usage</string>
//        <key>NSLocationUsageDescription</key>
//        <string>Some</string>
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation() /// user location one time. need delegate
        locationManager.requestWhenInUseAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    func finish() {
        locationManager.stopUpdatingLocation()
    }
    func clearShared() {
        LocationManager._shared = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        delegate?.didUpdate(location: location)
        didUpdate(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
