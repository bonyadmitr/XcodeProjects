//
//  FontPickerManager.swift
//  WeatherApp
//
//  Created by Bondar Yaroslav on 15/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class FontPickerManager {
    
    static let shared = FontPickerManager()
    
    var delegates = MulticastDelegate<UIViewController>()
    
    func updateUI(for fontName: String) {
        Fonts.setNames(base: fontName)
        AppearanceManager.shared.configurateAll()
        
        delegates.invoke { delegate in
            delegate.view.updateAllLabeles(with: fontName)
        }
    }
}
