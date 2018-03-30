//
//  Dispatch+Current.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 15/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Dispatch

/// Extensions to the DispatchQueue class
extension DispatchQueue {
    
    /// Extract the current dispatch queue's label name (Temp workaround until this is added to Swift 3.0 properly)
    public static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
