//
//  Promise+Catch.swift
//  OrderAppCustomerMy
//
//  Created by zdaecqze zdaecq on 11.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PromiseKit

extension Promise {
    func catchAndLog() {
        self.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func unblockScreen() -> Promise {
        UIApplication.shared.endIgnoringInteractionEvents()
        return self
    }
}
