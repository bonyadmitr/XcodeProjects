//
//  URLTask.swift
//  URLSessionWrapper
//
//  Created by Bondar Yaroslav on 6/6/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol URLTask {
    
    var task: URLSessionTask { get }
    var expectedContentLength: Int64 { get set }
    var completionHandler: DataResult? { get set }
    var progressHandler: ProgressHandler? { get set }
    
    func resume()
    func suspend()
    func cancel()
}

/// https://stackoverflow.com/a/45290601/5893286 
final class GenericTask {
    
    var completionHandler: DataResult?
    var progressHandler: ProgressHandler?
    var percentageHandler: PercentageHandler?
    
    let task: URLSessionTask
    let validator: ResponseValidator?
    var validatorError: Error?
    
    var progress = Progress()
    var expectedContentLength: Int64 = 1
    var buffer = Data()
    
    init(task: URLSessionTask, validator: ResponseValidator?) {
        self.task = task
        self.validator = validator
    }
    
    deinit {
        //        print("Deinit: \(task.originalRequest?.url?.absoluteString ?? "")")
    }
    
}
extension GenericTask: URLTask {
    
    func resume() {
        task.resume()
    }
    
    func suspend() {
        task.suspend()
    }
    
    func cancel() {
        task.cancel()
    }
}
