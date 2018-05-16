//
//  UICollectionView+Dequeue.swift
//  OLPortal
//
//  Created by Yaroslav Bondar on 31.03.17.
//  Copyright © 2017 sMediaLink. All rights reserved.
//

import UIKit

extension UICollectionView {
    // swiftlint:disable force_cast
    func dequeue <T: UICollectionViewCell>(reusable identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifierString, for: indexPath) as! T
    }
    
    func dequeueSupplementaryView <T: UICollectionReusableView>(kind: String, reusable identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierString, for: indexPath) as! T
    }
    // swiftlint:enable force_cast
}
