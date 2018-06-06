//
//  Result.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias VoidResult = (Result<Void>) -> Void
typealias BoolResult = (Result<Bool>) -> Void
typealias DataResult = (Result<Data>) -> Void
typealias HandlerResult<T> = (Result<T>) -> Void
typealias ArrayHandlerResult<T> = (Result<[T]>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}
