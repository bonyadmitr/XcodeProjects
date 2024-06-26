//
//  LocationManager.swift
//  LocationManager
//
//  Created by Bondar Yaroslav on 2/16/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import CoreLocation

// TODO: need to check
//#if TARGET_OS_TV
//[self.locationManager requestLocation];
//#else
//[self.locationManager startUpdatingLocation];
//#endif

protocol LocationManagerDelegate: class {
    func didUpdate(location: CLLocation)
}
extension LocationManagerDelegate {
    func didUpdate(location: CLLocation) {}
}

/// https://habrahabr.ru/post/271505/
/// я бы ещё добавил, что когда мы добавляем permission на location update (в background mode),
/// при публикации приложения в Apple Store нужно обязательно не забыть в конце дописать:
/// Continued use of GPS running in the background can dramatically decrease battery life
/// иначе rejection
///
/// Privacy - Location When In Use Usage Description
/// Privacy - Location Usage Description
//<key>NSLocationWhenInUseUsageDescription</key>
//<string>In usage</string>
//<key>NSLocationUsageDescription</key>
//<string>Some</string>
class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationManagerDelegate?
    var didUpdate: (_ location: CLLocation) -> Void = {_ in}
    
    override init() {
        super.init()
        
        /// need to add: Capabilities - UIBackgroundModes - Location updates
        /// receive location updates when suspended
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    func finish() {
        locationManager.stopUpdatingLocation()
    }
    
    /// calls delegate "locationManager(_ manager: CLLocationManager, didUpdateLocations" 2 times
    func getLocationOneTime() {
        locationManager.requestLocation() /// user location one time. need delegate
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO: request again
    }
}






