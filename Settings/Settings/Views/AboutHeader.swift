//
//  AboutHeader.swift
//  Settings
//
//  Created by Bondar Yaroslav on 11/13/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class AboutHeader: UITableViewHeaderFooterView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    
    /// for UIAppearance (not working with UIViews)
    @objc dynamic var color: UIColor = .black {
        didSet {
            imageView.tintColor = color /// can be used window.tintColor (remove this set)
            label.textColor = color
            versionLabel.textColor = color
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        //        if #available(iOS 11.0, *) {
        //            safeAreaLayoutGuide.topAnchor
        //            directionalLayoutMargins
        //        } else {
        //        }
        
        /// addSubview before activate constraints
        addSubview(label)
        addSubview(versionLabel)
        addSubview(imageView)
        
        let constant: CGFloat = 8
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /// defailt constraint priority is 1000
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        //imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //imageView.setContentCompressionResistancePriority(UILayoutPriority(100), for: .vertical)
        //layoutMargins.bottom
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: constant).isActive = true
        label.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -constant).isActive = true
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        
        versionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        versionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant).isActive = true
        versionLabel.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
    }
}
