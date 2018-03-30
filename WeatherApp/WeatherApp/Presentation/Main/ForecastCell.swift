//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 30/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureLabel: UILabel!
    @IBOutlet fileprivate weak var pressureLabel: UILabel!
    @IBOutlet fileprivate weak var humidityLabel: UILabel!
    @IBOutlet fileprivate weak var windSpeedLabel: UILabel!
    @IBOutlet fileprivate weak var iconLabel: UILabel!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    
    let formatter = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 2, height: 2)
        
        formatter.locale = LocalizationManager.shared.locale
    }
    
    func fill(with object: WeatherForecast) {
        let date = Date(timeIntervalSince1970: TimeInterval(object.dateInterval))
        fill(date: date)
        
        temperatureLabel.text = "\(object.temperature)"
        pressureLabel.text = "\(Int(object.pressure * 0.75006375541921)) mmHg"
        humidityLabel.text = "\(object.humidity) %"
        windSpeedLabel.text = "\(object.windSpeed) m/s"
        infoLabel.text = object.info
        iconLabel.text = object.icon //URL(string: "http://openweathermap.org/img/w/\(model.icon).png")!
    }
    
    private func fill(date: Date) {
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: date)
        //        formatter.dateFormat = "dd.MM"
        //        self.date.value = formatter.string(from: date)
        //        formatter.dateFormat = "HH:mm"
        //        time.value = formatter.string(from: date)
    }
}
