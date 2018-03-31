//
//  ViewController.swift
//  Networking
//
//  Created by Bondar Yaroslav on 28.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "some_photo")!
        let data = UIImagePNGRepresentation(image)!
        
//        AuthorizationToken.token = "Basic YWNjXzE4MTM2ZmRhOWIyODQ5YzpjMzYzNjU2NzVlODFkYWQ1OGJmYzgzYTVmMTMxYWJmNA=="
//        let sm = Alamofire.SessionManager.default
//        sm.adapter = AuthorizationAdapter.shared
        
        //                    .authenticate(user: "acc_18136fda9b2849c", password: "c36365675e81dad58bfc83a5f131abf4")
        
        let httpHeaders = ["Authorization": "Basic YWNjXzE4MTM2ZmRhOWIyODQ5YzpjMzYzNjU2NzVlODFkYWQ1OGJmYzgzYTVmMTMxYWJmNA=="]
        
        upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "imagefile", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: "https://api.imagga.com/v1/content", headers: httpHeaders, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let uploadRequest, _, _):

                uploadRequest.validate().responseJSON() { responseJSON in
                    switch responseJSON.result {
                    case .success(let value):
                        print(value)

                    case .failure(let error):
                        print(error)
                    }
                }

            case .failure(let error):
                print(error)
            }
        })
        
        
    }
}


//        func multipartFormDataToSend(multipartFormData: MultipartFormData) {
//            multipartFormData.append(Data(), withName: "avatar", fileName: "avatar", mimeType: "image/jpeg")
//        }
//
//        upload(multipartFormData: multipartFormDataToSend, to: "Path", encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let uploadRequest, let streamingFromDisk, let streamFileURL):
//                print(uploadRequest)
//                print(streamingFromDisk)
//                print(streamFileURL)
//
//
//                uploadRequest.validate().responseJSON() { responseJSON in
//
//                    switch responseJSON.result {
//                    case .success(let value):
//                        print(value)
//
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        })




//        request("http://jsonplaceholder.typicode.com/posts").response { response in
//            guard
//                let data = response.data,
//                let string = String(data: data, encoding: .utf8)
//                else { return }
//            print(string)
//        }


//        request("https://s-media-cache-ak0.pinimg.com/originals/ef/6f/8a/ef6f8ac3c1d9038cad7f072261ffc841.jpg")
//            .validate()
//            .downloadProgress { progress in
//                print("totalUnitCount:\n", progress.totalUnitCount)
//                print("completedUnitCount:\n", progress.completedUnitCount)
//                print("fractionCompleted:\n", progress.fractionCompleted)
//                print("localizedDescription:\n", progress.localizedDescription)
//                print("---------------------------------------------")
//            }
//            .response { response in
//                guard
//                    let data = response.data,
//                    let image = UIImage(data: data)
//                    else { return }
//                print(image)
//        }



//        request("http://localhost:3000/posts").responseJSON { responseJSON in
//            print(responseJSON)
//        }

//        request("http://localhost:3000/posts").responseJSON { responseJSON in
//
//            guard let statusCode = responseJSON.response?.statusCode else { return }
//            print("statusCode: ", statusCode)
//
//            if (200..<300).contains(statusCode) {
//                let value = responseJSON.result.value
//                print("value: ", value)
//            } else {
//                let error = responseJSON.result.error
//                print("error: ", error)
//            }
//        }


//        request("http://jsonplaceholder.typicode.com/posts").responseJSON { responseJSON in
//
//            switch responseJSON.result {
//            case .success(let value):
//                guard let posts = Post.getArray(from: value) else { return }
//                print(posts)
//
//            case .failure(let error):
//                print(error)
//            }
//        }




//http://jsonplaceholder.typicode.com/posts


//    print(responseJSON.result.value)
//    print("id: ", (responseJSON.result.value as! Array<[String: Any]>)[0]["id"]!)



//            debugPrint(responseJSON)


//        NetworkingService.instance.response()
//        NetworkingService.instance.responseJSON { (posts, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            print(posts!)
//        }
//        NetworkingService.instance.responseData()
//        NetworkingService.instance.responseString()
