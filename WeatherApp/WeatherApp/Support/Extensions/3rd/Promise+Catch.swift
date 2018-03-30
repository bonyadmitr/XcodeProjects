//
//  Promise+Catch.swift
//  iGuru
//
//  Created by Yaroslav Bondar on 18.01.17.
//  Copyright © 2017 Yaroslav Bondar. All rights reserved.
//

import PromiseKit

extension Promise {
    func catchAndLog(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        self.catch { error in
            
            var res = "⚠️ catchAndLog in "
            let file = (fileName as NSString).lastPathComponent
            let line = ":\(lineNumber)"
            res += "[\(file)\(line)] "
            res += "\(functionName) ⚠️\n"
            
            print(res, error)
        }
    }
}
