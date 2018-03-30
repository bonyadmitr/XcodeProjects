//
//  PlacesController.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 06/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import MapKit

// MARK: PlacesControllerDelegate
protocol PlacesControllerDelegate: class {
    func didSelect(place: Place)
}

// MARK: - PlacesController
class PlacesController: UITableViewController {
    
    var places: [Place] = [] {
        didSet {
            tableView.reloadData()
        }
    }
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
        
        if places.notEmpty {
            tableView.backgroundView = nil
            numberOfRows = places.count
        } else {
            let noDataLabel = UILabel()
            noDataLabel.lzText = "not_found"
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        cell.textLabel?.attributedText = place.full.boldGooglePlaceString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        FabricManager.shared.log(cityName: place.full.string)
        delegate?.didSelect(place: place)
    }
}
