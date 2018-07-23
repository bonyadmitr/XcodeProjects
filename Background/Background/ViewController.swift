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

import XCGLogger

extension XCGLogger {
    static func documentsFolderUrl(withComponent: String) -> URL {
        let documentsUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentsUrls[documentsUrls.endIndex - 1].appendingPathComponent(withComponent)
    }
}

// the global reference to logging mechanism to be available in all files
let log: XCGLogger = {
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
    
    let logPath = XCGLogger.documentsFolderUrl(withComponent: "app.log")
    
    let autoRotatingFileDestination = AutoRotatingFileDestination(owner: log,
                                                                  writeToFile: logPath,
                                                                  identifier: "advancedLogger.fileDestination",
                                                                  shouldAppend: true,
                                                                  appendMarker: "-- Relaunched App --",
                                                                  attributes: [.protectionKey : FileProtectionType.completeUntilFirstUserAuthentication],
                                                                  maxFileSize: 5_242_880 * 10,
                                                                  maxTimeInterval: 24 * 60 * 60 * 10,
                                                                  archiveSuffixDateFormatter: nil)
    autoRotatingFileDestination.outputLevel = .debug
    autoRotatingFileDestination.showLogIdentifier = true
    autoRotatingFileDestination.showFunctionName = true
    autoRotatingFileDestination.showThreadName = true
    autoRotatingFileDestination.showLevel = true
    autoRotatingFileDestination.showFileName = true
    autoRotatingFileDestination.showLineNumber = true
    autoRotatingFileDestination.showDate = true
    autoRotatingFileDestination.logQueue = XCGLogger.logQueue
    
    log.add(destination: autoRotatingFileDestination)
    
    log.logAppDetails()
    
    return log
}()

func debugLog(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    
    log.logln(.debug, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo, closure: closure)
    
    let resultString = String(describing: closure() ?? "nil") 
    print(resultString)
}

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
    
    var lastLocation: CLLocation?
    var lastDate: Date?
}

extension ViewController: LocationManagerDelegate {
    func didUpdate(location: CLLocation) {
        
        if let lastLocation = lastLocation {
            let distance = lastLocation.distance(from: location) /// meters
            debugLog("distance: \(distance)")
        }
        
        if let lastDate = lastDate {
            let newDate = Date()
            let timeDifference = -lastDate.timeIntervalSince(newDate)
            debugLog("timeDifference: \(timeDifference)")
            self.lastDate = newDate
        } else {
            lastDate = Date()
        }
        
        lastLocation = location
//        debugLog(location)
    }
}
