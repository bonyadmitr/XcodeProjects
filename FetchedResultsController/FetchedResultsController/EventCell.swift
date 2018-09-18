//
//  EventCell.swift
//  EventsCountdown
//
//  Created by Bondar Yaroslav on 7/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class EventCell: UITableViewCell {
    func fill(with event: EventDB) {
        textLabel?.text = event.title
        detailTextLabel?.text = event.date?.description
    }
}
