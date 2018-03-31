//
//  DetailInteractorIO.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

// MARK: - Interactor Input
protocol DetailInteractorInput: class {

}

// MARK: - Interactor Output
protocol DetailInteractorOutput: class {
	func failed(with error: Error)
}
