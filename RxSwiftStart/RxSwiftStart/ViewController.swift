//
//  ViewController.swift
//  RxSwiftStart
//
//  Created by zdaecqze zdaecq on 16.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //just 1
        //of 1,1,1,1
        //from []
        
        [10,30,1,2,45]
            .map { $0 * 10 }
            .filter { $0 > 100 }
            .forEach{ print($0) }
        
        //MARK: - Observable
        print("\nObservable")
        
        _ = Observable
            .of(10,30,1,2,45)
            .map { $0 * 10 }
            .filter { $0 > 100 }
            .subscribe { print($0) }
            .dispose()
        
        
        
        _ = getInt()
            .subscribe { print($0)}
            .addDisposableTo(disposeBag)
        
        let observer = Observable
            .of(10,30,1,2,45)
            .subscribe(
                onNext: { (value) in
                    print(value)
                }, onError: { (error) in
                    print(error)
                }, onCompleted: { 
                    print("onCompleted")
                }, onDisposed: { 
                    print("onDisposed")
            })
//            .addDisposableTo(disposeBag)
        observer.addDisposableTo(disposeBag)
        
        
        
        //MARK: - PublishSubject
        print("\nPublishSubject")
        
        
        let subject = PublishSubject<String>()
        
        _ = subject.subscribe {
            print("subscribe 1: \($0)")
        }
        
        subject.on(Event<String>.next("Hello"))
        
        _ = subject.subscribe {
            print("subscribe 2: \($0)")
        }
        
        subject.onNext("Hi!!!")
        
        //"addDisposableTo" don't end subscribes and "dispose()" do
        //subject.addDisposableTo(disposeBag)
        
        subject.dispose()
        subject.onNext("Hi!!! 222")
        
        //MARK: - ReplaySubject
        print("\nReplaySubject")
        
        let subject2 = ReplaySubject<Int>.create(bufferSize: 3)
        
        subject2.onNext(1)
        subject2.onNext(2)
        subject2.onNext(3)
        subject2.onNext(4)
        subject2.onNext(5)
        
        _ = subject2.subscribe {
            print($0)
        }.addDisposableTo(disposeBag)
        subject2.onNext(6)
        
        //MARK: - Variable
        print("\nVariable")
        
        let variable = Variable("A")
        
        variable.asObservable().subscribe {
            print($0)
        }.addDisposableTo(disposeBag)
        
        variable.value = "BBB"
    }


    func getInt() -> Observable<Int> {
        return Observable.from([10, 4, 1])
    }
}

