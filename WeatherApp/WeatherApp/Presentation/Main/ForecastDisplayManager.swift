//
//  ForecastDisplayManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 30/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ForecastDisplayManager: NSObject {
    
    weak var tableView: UITableView! {
        didSet { tableView.dataSource = self }
    }
    
    var forecasts: [WeatherForecast] = [] {
        didSet { tableView.reloadData() }
    }
}
extension ForecastDisplayManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: ForecastCell.self, for: indexPath)
        cell.fill(with: forecasts[indexPath.row])
        return cell
    }
}
