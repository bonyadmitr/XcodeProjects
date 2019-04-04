//
//  ViewController.swift
//  Background
//
//  Created by Bondar Yaroslav on 7/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let batteryManager = BatteryManager()
    
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
    
    
    var objects = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog("ViewController viewDidLoad")
        
//        for _ in 1...500 {
//            objects.append(MKMapView())
//        }
//        debugLog("500 MKMapView created, about 200mb of memory")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugLog("ViewController viewDidAppear")
        debugLog("BatteryManager state: \(BatteryManager.isCharging)")
    }

    
    @IBAction func sendEmail(_ sender: UIBarButtonItem) {
        
        if let logUrl = LoggerConstants.logUrl,
            FileManager.default.fileExists(atPath: logUrl.path),
            let logData = try? Data(contentsOf: logUrl)
        {
            let attachment = MailAttachment(data: logData, mimeType: "text/plain", fileName: "logs.txt")
            
            EmailSender.shared.send(message: "",
                                    subject: "Background Test",
                                    to: ["zdaecq@gmail.com"],
                                    attachments: [attachment],
                                    presentIn: self)
        }
    }
}
