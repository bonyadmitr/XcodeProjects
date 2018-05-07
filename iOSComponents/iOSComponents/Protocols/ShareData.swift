//
//  ShareData.swift
//  LifeboxShared
//
//  Created by Bondar Yaroslav on 2/27/18.
//  Copyright © 2018 LifeTech. All rights reserved.
//

import UIKit

open class ShareData {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var image: UIImage? {
        return nil //Images.noDocuments
    }
    
    var name: String {
        return url.lastPathComponent
    }
    
    var contentType: String {
        let contentType: String
        
        if self is ShareImage {
            contentType = ""//url.imageContentType
        } else if self is ShareVideo {
            contentType = "video/mp4"
        } else {
            contentType = ""//url.mimeType
        }
        return contentType
    }
}
extension ShareData: Equatable {
    public static func ==(lhs: ShareData, rhs: ShareData) -> Bool {
        return lhs.url == rhs.url
    }
}

final class ShareImage: ShareData {
    override var image: UIImage? {
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }
}

final class ShareVideo: ShareData {
    override var image: UIImage? {
        return nil//url.videoPreview
    }
}
