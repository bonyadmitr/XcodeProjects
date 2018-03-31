//
//  PlacesController.swift
//  MapKitTest
//
//  Created by Bondar Yaroslav on 28/01/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import MapKit

// MARK: PlacesControllerDelegate
protocol PlacesControllerDelegate: class {
    func didSelect(place: MKMapItem)
}


//    "<MKMapItem: 0x841ee590> {\n    isCurrentLocation = 0;\n    name = \"Mail Boxes Etc.\";\n    phoneNumber = \"\\U200e+7 (861) 244-01-30\";\n    placemark = \"Mail Boxes Etc., ulitsa Babushkina, 215, Russia, Krasnodarskiy kray, gorodskoy okrug Gorod Krasnodar, Krasnodar @ <+45.04910300,+38.96015800> +/- 0.00m, region CLCircularRegion (identifier:'<+45.04910300,+38.96015800> radius 14147.27', center:<+45.04910300,+38.96015800>, radius:14147.27m)\";\n}"

// MARK: - PlacesController
class PlacesController: UITableViewController {
    
    var places: [MKMapItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    weak var searchController: UISearchController!
    weak var delegate: PlacesControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlacesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if places.count > 0 {
            tableView.backgroundView = nil
            numberOfRows = places.count
        } else {
            let noDataLabel = UILabel()
            noDataLabel.text = "Not found"
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        cell.textLabel?.text = place.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(place: places[indexPath.row])
        searchController.isActive = false
    }
}

