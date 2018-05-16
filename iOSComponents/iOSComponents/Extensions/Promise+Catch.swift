//
//  Promise+Catch.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 18.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import PromiseKit

extension Promise {
    
    func catchAndShow() {
        self.catch { error in
//            ErrorHandler.catch(error, title: title)
        }
    }
    
    func catchAndLog() {
        self.catch { error in
            print(error.localizedDescription)
        }
    }
    
}
