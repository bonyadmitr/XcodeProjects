//
//  IndexRequestHandler.swift
//  SpotlightExtension
//
//  Created by Bondar Yaroslav on 9/16/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import CoreSpotlight

class IndexRequestHandler: CSIndexExtensionRequestHandler {

    override func searchableIndex(_ searchableIndex: CSSearchableIndex, reindexAllSearchableItemsWithAcknowledgementHandler acknowledgementHandler: @escaping () -> Void) {
        // Reindex all data with the provided index
        
        acknowledgementHandler()
    }
    
    override func searchableIndex(_ searchableIndex: CSSearchableIndex, reindexSearchableItemsWithIdentifiers identifiers: [String], acknowledgementHandler: @escaping () -> Void) {
        // Reindex any items with the given identifiers and the provided index
        
        acknowledgementHandler()
    }
    
    override func data(for searchableIndex: CSSearchableIndex, itemIdentifier: String, typeIdentifier: String) throws -> Data {
        // Replace with Data representation of requested type from item identifier
        
        return Data()
    }
    
    override func fileURL(for searchableIndex: CSSearchableIndex, itemIdentifier: String, typeIdentifier: String, inPlace: Bool) throws -> URL {
        // Replace with to return file url based on requested type from item identifier
        
        return URL(string:"file://")!
    }
    
}
