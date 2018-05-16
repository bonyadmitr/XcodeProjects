//
//  CollectionTableView.swift
//  CollectionViewLayouts
//
//  Created by Bondar Yaroslav on 10.01.17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class CollectionTableView: UITableView {
    
    var contentOffsets: [CGPoint]!
    //    var currentRow: Int!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        contentOffsets = Array(repeating: CGPoint.zero, count: numberOfRows(inSection: 0))
    }
    
//    func contentOffset(for indexPath: IndexPath) -> CGPoint {
//        if contentOffsets.count <= indexPath.row  {
//            return CGPoint.zero
//        }
//        return contentOffsets[indexPath.row]
//    }
}
