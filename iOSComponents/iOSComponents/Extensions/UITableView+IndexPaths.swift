//
//  UITableView+IndexPaths.swift
//  OLPortal
//
//  Created by Nikita Kovalenok on 01.02.17.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

extension UITableView {
  func indexPathsForRowsInSection(_ section: Int) -> [IndexPath] {
    return (0..<self.numberOfRows(inSection: section)).map { IndexPath(row: $0, section: section) }
  }
}
