//
//  HttpController.swift
//  SwiftMapRequest
//
//  Created by Rustam N on 24.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import UIKit

class HttpController : Controller {
    
    static func doGetRequest(_ urlWithParameters : URL, viewController: UIViewController?, whenComplete : DataTaskDelegate) {
        
        let request = NSMutableURLRequest(url:urlWithParameters);
        request.httpMethod = "GET"
        sendRequest(request, viewController: viewController, whenComplete: whenComplete)
    }
    
    fileprivate static func sendRequest(_ request : NSMutableURLRequest, viewController : UIViewController?, whenComplete : DataTaskDelegate) {
        
        request.httpShouldHandleCookies = false
        
        let queue : OperationQueue = OperationQueue.main
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue) {
            response, data, error in
            guard error == nil else{ whenComplete.getResponce(nil); return }
            whenComplete.getResponce(data)
        }
    }
    
}



