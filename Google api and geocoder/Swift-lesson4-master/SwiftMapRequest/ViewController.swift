//
//  ViewController.swift
//  SwiftMapRequest
//
//  Created by Ildar Zalyalov on 24.02.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//
import MapKit
import UIKit

protocol HandleMapSearch {
    func dropPinZoomIn(with placemark: MKPlacemark)
}


class ViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var selectedPin: MKPlacemark? = nil
    var resultSearchController: UISearchController? = nil
    let realmManager = RealmManagement()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search city"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        dropPinZoomIn(with: MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 55.7887400, longitude: 49.1221400), addressDictionary: [:]))
    }

    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    
    @IBAction func myPositionButtonAction(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func lastButtonAction(_ sender: UIButton) {
        let city = realmManager.getNeededCityAndAttractionsFromRealm()
        dropPinZoomIn(with: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude), addressDictionary: [:]),
                      attractionsArr: Array(city.attractions))
    }
}





extension ViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ErrorAllert(alertTitle: "Connection problems", message: "Check your internet", actionTitle: "ok", controller: UIApplication.getTopViewController()!)
    }
}



extension ViewController: HandleMapSearch, DataTaskDelegate {
    func dropPinZoomIn(with placemark: MKPlacemark){
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        
        let cordinate = CordinateWithRadiuSstruct.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude, radius: 20000)
        let urlString = "\(Constants.baseUrl)location=\(cordinate.latitude),\(cordinate.longitude)&radius=\(cordinate.radius)&types=point_of_interest&key=\(Constants.key)"
        let encodingUrl = URL(string: urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
        HttpController.doGetRequest(encodingUrl!, viewController: self, whenComplete: self)
    }
    
    func getResponce(_ result: Data?) {
        guard let httpRequestResult = result else {
            ErrorAllert(alertTitle: "Connection problems", message: "Check your internet", actionTitle: "ok", controller: UIApplication.getTopViewController()!)
            return
        }
        
        let jsonReaderResult = JSONReader.jsonReader(usableData: httpRequestResult)
        guard let LjsonReaderResult = jsonReaderResult else{ErrorAllert(alertTitle: "Some problems with json", message: "Plese try later", actionTitle: "ok", controller: UIApplication.getTopViewController()!); return}
        
        var attractionsArr: [Attraction] = []
        let city = City()
        city.latitude = selectedPin!.coordinate.latitude
        city.longitude = selectedPin!.coordinate.longitude
        
        for place in LjsonReaderResult {
            let coordinate = CLLocationCoordinate2D.init(latitude: place.latitude, longitude: place.longitude)
            let dataForAnnotation = AnnotationDataStruct.init(placeName: place.name, address: place.address, coordinate: coordinate)
            let attraction = Attraction()
            attraction.latitude = dataForAnnotation.coordinate.latitude
            attraction.longitude = dataForAnnotation.coordinate.longitude
            attraction.placeName = dataForAnnotation.placeName
            attraction.address = dataForAnnotation.address
            attractionsArr.append(attraction)
            mapView.addAnnotation(GetAnnotation(data: dataForAnnotation))
            
        }
        realmManager.save(city: city, attractionsArr: attractionsArr)
    }
    
    func dropPinZoomIn(with placemark: MKPlacemark, attractionsArr: [Attraction]){
        selectedPin = placemark
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        for attraction in attractionsArr {
            let coordinate = CLLocationCoordinate2D.init(latitude: attraction.latitude, longitude: attraction.longitude)
            let dataForAnnotation = AnnotationDataStruct.init(placeName: attraction.placeName, address: attraction.address, coordinate: coordinate)
            mapView.addAnnotation(GetAnnotation(data: dataForAnnotation))
        }
    }
}



extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        return pinView
    }
}







