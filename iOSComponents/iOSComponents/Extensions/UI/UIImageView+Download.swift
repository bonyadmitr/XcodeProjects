//
//  UIImageView+Download.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    func downloadFrom(link: String?) {
        guard let link = link, let url = URL(string: link) else { return }
        downloadFrom(url: url)
    }
}
