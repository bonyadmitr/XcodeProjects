//
//  DetailInteractor.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 28/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class DetailInteractor {
    weak var output: DetailInteractorOutput?

	//let service: Service
	//
	//init(service: Service) {
	//    self.service = service
	//}
    
    deinit {
        print("- DetailInteractor")
    }
}

// MARK: - Interactor Input
extension DetailInteractor: DetailInteractorInput {
    
}
