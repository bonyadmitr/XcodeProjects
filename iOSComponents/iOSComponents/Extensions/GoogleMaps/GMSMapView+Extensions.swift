//
//  GMSMapViewExtensions.swift
//  OrderApp-Customer-iOS
//
//  Created by Yaroslav Bondar on 09.06.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

// MARK: Need to import GoogleMaps framework to project

import GoogleMaps

extension GMSMapView {
    
    func addMarkerWith(coordinates coordinates: CLLocationCoordinate2D, title: String, iconName: String?) -> GMSMarker {
        let marker = GMSMarker(position: coordinates)
        marker.title = title
        marker.map = self
        
        if let iconName = iconName {
            marker.icon = UIImage(named: iconName)
        }
        
        return marker
    }
    
    func setCameraWith(coordinates coordinates: CLLocationCoordinate2D, zoom: Float) -> GMSCameraPosition {
        let camera = GMSCameraPosition.cameraWithTarget(coordinates, zoom: zoom)
        self.camera = camera
        return camera
    }
    
}
