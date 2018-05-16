//
//  Facebook+Extension.swift
//  AccountManager
//
//  Created by Bondar Yaroslav on 02/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import FacebookCore

extension GraphRequestProtocol {
    var accessToken: AccessToken? {
        return AccessToken.current
    }
    var apiVersion: GraphAPIVersion {
        return .defaultVersion
    }
    var httpMethod: GraphRequestHTTPMethod {
        return .GET
    }
}
