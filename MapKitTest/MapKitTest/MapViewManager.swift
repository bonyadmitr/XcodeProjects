//
//  MapViewManager.swift
//  MapKitTest
//
//  Created by Bondar Yaroslav on 29/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import MapKit

class MapViewManager: NSObject {
    
    weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var points: [CLLocationCoordinate2D] = []
    var polyline = MKPolyline()
    var isRecording = false
    var didUpdateSpeed: ((Double) -> Void)!
    
    init(mapView: MKMapView) {
        super.init()
        self.mapView = mapView
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func add(place: MKMapItem) {
        print(place)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = place.name
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: place.placemark.coordinate.latitude,
                                                            longitude: place.placemark.coordinate.longitude)
        
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pinAnnotationView.annotation!)
        mapView.setCenter(pointAnnotation.coordinate, animated: true)
    }
    
    func switchTrackingMode() {
        switch mapView.userTrackingMode {
        case .none:
            mapView.setUserTrackingMode(.follow, animated: true)
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .follow:
            mapView.setUserTrackingMode(.followWithHeading, animated: true)
        case .followWithHeading:
            mapView.setUserTrackingMode(.none, animated: true)
            mapView.showsUserLocation = false
        }
    }
    
    func startRecord() {
        locationManager.startUpdatingLocation()
        isRecording = true
    }
    
    func finishRecord() -> [CLLocationCoordinate2D] {
        locationManager.stopUpdatingLocation()
        let pointsCopy = points
        points = []
        isRecording = false
        return pointsCopy
    }
    
    func buildRoutes(with pointsArray: [[CLLocationCoordinate2D]]) {
        for points in pointsArray {
            let polyline = MKPolyline(coordinates: points, count: points.count)
            mapView.add(polyline)
        }
    }
}

extension MapViewManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.count == 0 { return }
        let location = locations.last!
        if location.horizontalAccuracy > 100 { return }
        
        let speed = location.speed * 1000 / 3600
        didUpdateSpeed(speed)
        
        points.append(location.coordinate)
        mapView.remove(polyline)
        polyline = MKPolyline(coordinates: &points, count: points.count)
        mapView.add(polyline)
    }
}


extension MapViewManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4
        renderer.lineCap = .round
        return renderer
    }
}
