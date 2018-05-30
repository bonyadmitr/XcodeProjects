//
//  PlacesController.swift
//  GooglePlaces
//
//  Created by zdaecqze zdaecq on 11.06.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import GoogleMaps


// MARK: PlacesControllerDelegate
protocol PlacesControllerDelegate : class {
    func didSelectPrediction(prediction: GMSAutocompletePrediction)
}



// MARK: - PlacesController
class PlacesController: UITableViewController {

    // MARK: Properties
    var placesArray : [GMSAutocompletePrediction] = []
    var searchController : UISearchController!
    weak var delegate: PlacesControllerDelegate?
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlacesController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.attributedText = getBoldedAttributedString(placesArray[indexPath.row].attributedFullText)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectPrediction(placesArray[indexPath.row])
        searchController.active = false
    }
}


// MARK: - NSAttributedString helper
func getBoldedAttributedString(string: NSAttributedString) -> NSAttributedString {
    
    let regularFont = UIFont.systemFontOfSize(UIFont.labelFontSize())
    let boldFont = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
    
    let bolded = string.mutableCopy() as! NSMutableAttributedString
    bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, inRange: NSMakeRange(0, bolded.length), options: .LongestEffectiveRangeNotRequired) { (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
        let font = (value == nil) ? regularFont : boldFont
        bolded.addAttribute(NSFontAttributeName, value: font, range: range)
    }
    
    return bolded
}


