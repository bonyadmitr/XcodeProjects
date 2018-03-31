//
//  ViewController.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 02.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var seasonsContainer: UIView!
    
    var didTapProfile: () -> () = {}
    var didSelectSeason: (Season) -> () = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleSeasons = [
            Season(number: 1, title: "Season One"),
            Season(number: 2, title: "Season Two")
        ]
        
        let seasonsVC = GenericTableViewController(items: sampleSeasons) { (cell: SeasonCell, season) in
            cell.config(with: season)
        }
        seasonsVC.didSelect = didSelectSeason
        add(child: seasonsVC, to: seasonsContainer)
    }

    @IBAction func profileBarButton(_ sender: UIBarButtonItem) {
        didTapProfile()
    }
}

