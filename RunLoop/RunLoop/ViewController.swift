//
//  ViewController.swift
//  RunLoop
//
//  Created by Bondar Yaroslav on 7/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import UIKit


// TODO: Port `RunLoop.main.add(Port(), forMode: .default)`
final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let areaSelectionView = AreaSelectionView()
        areaSelectionView.frame = view.frame
        areaSelectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(areaSelectionView)
        
        let timer = Timer(timeInterval: 2, repeats: true) { (_) in
//            sleep(1)
//            print("sleep end", RunLoop.current.currentMode!.rawValue)
            print("default", RunLoop.current.currentMode!.rawValue)
        }
        timer.tolerance = 0.1
        RunLoop.main.add(timer, forMode: .default)
       
        
        let timerTracking = Timer(timeInterval: 1, repeats: true) { (_) in
            print("tracking", RunLoop.current.currentMode!.rawValue)
        }
        timerTracking.tolerance = 0.1
        
        RunLoop.main.add(timerTracking, forMode: .tracking)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            // TODO: check scrollViewWillBeginDragging + scrollViewDidEndScrolling https://stackoverflow.com/a/44113900/5893286
            /// not working https://stackoverflow.com/a/15619927/5893286
            //let tableView = self.view.subviews.first!.subviews.first!
            //let isScrolling = tableView.layer.animation(forKey: "bounds") != nil
            //print("isScrolling", isScrolling)
            
            print("isScrolling anything", RunLoop.current.currentMode == .tracking)
            if RunLoop.current.currentMode == .tracking {
                let timer = Timer(timeInterval: 0, repeats: false) { (_) in
                    print("delayed reload data when user stop scroll intaraction")
                }
                
                RunLoop.main.add(timer, forMode: .default)
            }
            
        }
        
        
        
        //        func q() {
        //            RunLoop.main.perform(inModes: [.default]) {
        //                print("- someSleep start")
        //                print("", RunLoop.current.currentMode!.rawValue)
        //                sleep(1)
        //                print("someSleep end")
        //                DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
        //                    q()
        //                })
        //
        //            }
        //        }
        //
        //        q()
        
        //        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        //
        //            sleep(1)
        //
        //            func someSleep() {
        //                print("someSleep start")
        //                sleep(2)
        //                print("someSleep end")
        //            }
        
        //            DispatchQueue.main.async {
        //                someSleep()
        //            }
        
        /// https://youtu.be/wA_392H7JeU
        /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html
        /// https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html
        ///
        /// https://stackoverflow.com/questions/43825263/how-to-exit-a-runloop
        /// https://stackoverflow.com/a/4260609/5893286
        /// https://github.com/ReactiveX/RxSwift/blob/master/RxBlocking/RunLoopLock.swift
        /// https://habr.com/ru/company/otus/blog/590319/
        //            CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue) {
        //                someSleep()
        //            }
        
        //            RunLoop.main.perform(inModes: [.tracking]) {
        //                someSleep()
        //            }
        
        
        //            CFRunLoopStop(CFRunLoopGetMain())
        //            print(RunLoop.current.currentMode!.rawValue)
        // Stop the saved run loop
        //        guard let runLoop = self.runLoop else {
        //            assertionFailure()
        //            return
        //        }
        //        CFRunLoopStop(runLoop)
        
        //        CFRunLoopStop(CFRunLoopGetCurrent())
        
        //        let isStartedInTrackingMode = RunLoop.current.run(mode: .default, before: Date.distantFuture)
        //        assert(isStartedInTrackingMode)
        
        //CFRunLoopRun()
        
        /// Store a reference to the current run loop
        //        runLoop = CFRunLoopGetCurrent()
        //        assert(runLoop == CFRunLoopGetMain(), "it must be main RunLoop")
        //        print(RunLoop.current.currentMode!.rawValue)
        //
        //        CFRunLoopStop(CFRunLoopGetCurrent())
        //        //        RunLoop.Mode.tracking
        //        //        CFRunLoopRunInMode(CFRunLoopMode.commonModes!, 10, false)
        //        let q = RunLoop.current.run(mode: .common, before: Date.distantFuture)
        //            let isChangedRunLoopMode = RunLoop.current.run(mode: .tracking, before: Date.distantFuture)
        //            assert(isChangedRunLoopMode)
        
        
        //        }
        
        
    }


}


/// https://stackoverflow.com/a/42722478/5893286
final class AreaSelectionView: UIView {
    
    /// for normal animation, must be even number of elements in the array
    private static let lineDashPattern = [15, 5]
    
    private var startPoint: CGPoint?
    
    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        /// line dash length
        /// needs adapt with "dashAnimation". done by constatnt "lineDashPattern" + reduce
        shapeLayer.lineDashPattern = lineDashPattern as [NSNumber]
        /// line dash color
        if #available(iOS 13.0, *) {
            shapeLayer.strokeColor = UIColor.label.cgColor
        } else {
            shapeLayer.strokeColor = UIColor.black.cgColor
        }
        /// inner rect color
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    
    private let dashAnimation: CABasicAnimation = {
        assert(lineDashPattern.count % 2 == 0, "for normal animation, must be even number of elements in the array")
        
        /// 26.6 = (15+5) / 0.75
        /// 0.75 is nice duration for lineDashPattern = [15, 5]
        let animationSpeedNormalizationValue: Double = 26.6
        
        /// dashes + empty spaces
        let oneSectionLength = Double(lineDashPattern.reduce(0, + ))
        
        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = oneSectionLength
        /// controls animation speed. by longer dashes it be faster
        dashAnimation.duration = oneSectionLength / animationSpeedNormalizationValue
        dashAnimation.repeatCount = .infinity
        return dashAnimation
    }()
    
    private var runLoop: CFRunLoop?
    
    var isTouchStarted = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            assertionFailure("\(touches.count)")
            return
        }
        
        self.startPoint = point
        self.layer.addSublayer(self.shapeLayer)
        
        /// "removeAnimation" doesn't need bcz it was removed by "removeFromSuperlayer"
        self.shapeLayer.add(self.dashAnimation, forKey: "linePhase")
        
        
        // TODO: check with CADisplayLink
        isTouchStarted = true
        while isTouchStarted {
            //RunLoop.current.run(mode: .tracking, before: Date.distantFuture)
            let isChangedRunLoopMode = RunLoop.current.run(mode: .tracking, before: Date.distantFuture)
            assert(isChangedRunLoopMode)

        }
        let isChangedRunLoopMode = RunLoop.current.run(mode: .default, before: Date.distantFuture)
        assert(isChangedRunLoopMode)
        
        //RunLoop.current.acceptInput(forMode: .tracking, before: Date.distantFuture)
//        let isChangedRunLoopMode = RunLoop.current.run(mode: .tracking, before: Date.distantFuture)
//        assert(isChangedRunLoopMode)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            assertionFailure("\(touches.count)")
            return
        }
        
        guard let startPoint = self.startPoint else {
            assertionFailure("startPoint should be set in touchesBegan")
            return
        }
        
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x, y: point.y))
        path.addLine(to: point)
        path.addLine(to: CGPoint(x: point.x, y: startPoint.y))
        path.closeSubpath()
        self.shapeLayer.path = path
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endTouches()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        endTouches()
    }
    
    private func endTouches() {
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer.path = nil
        
        let isChangedRunLoopMode = RunLoop.current.run(mode: .default, before: Date.distantFuture)
        assert(isChangedRunLoopMode)
        //
        //        print("--- !!! 1")
        //        RunLoop.main.perform(inModes: [.tracking]) {
        //            sleep(2)
        //            print("--- !!! 2")
        //        }
    }
}
