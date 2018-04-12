//
//  ViewController.swift
//  MemoryTests
//
//  Created by Bondar Yaroslav on 13/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    deinit {
        print("- deinit ViewController")
    }
    
    lazy var service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Weak внутри weak
//        autoreleasepool in dispatch queue

        test6()
    }
    
    
    
    func test1() {
        service.getSome {
            print("getSome 1")
            self.view.backgroundColor = .red
        }

    }
    
    func test2() {
        service.getSome { [weak self] in
            print("getSome 1")
            guard let `self` = self else {
                return
            }
            self.view.backgroundColor = .red
        }

    }
    
    func test3() {
        Service().getSome {
            print("getSome 2")
            self.view.backgroundColor = .blue
        }

    }
    
    func test4() {
        Service().getSome { [weak self] in
            print("getSome 2")
            guard let `self` = self else {
                return
            }
            self.view.backgroundColor = .blue
        }

    }
    
    func test5() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {  [weak self] in
            print("global 3")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {// [weak self] in
                print("main 3")
                guard let `self` = self else {
                    return
                }
                self.view.backgroundColor = .blue
            }
        }

    }
    
    func test6() {
        service.getSome { [weak self] in
            print("getSome 1")
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {//  [weak self] in
                print("global 3")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {// [weak self] in
                    print("main 3")
                    guard let `self` = self else {
                        return
                    }
                    self.view.backgroundColor = .blue
                }
            }
        }
    }
}

typealias VoidHandler = () -> Void

class Service {
    
    deinit {
        print("- deinit Service")
    }
    
    func getSome(handler: @escaping VoidHandler) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                handler()
            }
        }
    }
}
