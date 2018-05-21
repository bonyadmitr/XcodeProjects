//
//  Bundle+Path.swift
//  FFNN
//
//  Created by Bondar Yaroslav on 23/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Bundle {
    func path(for resource: String) -> URL? {
        guard let path = self.path(forResource: resource, ofType: nil) else { return nil }
        let url = URL(fileURLWithPath: path)
        return url
        
        //        let executablePath = self.executablePath!
        //        let projectURL = NSURL(fileURLWithPath: executablePath).deletingLastPathComponent!
        //        return projectURL.appendingPathComponent(resource)
    }
}
