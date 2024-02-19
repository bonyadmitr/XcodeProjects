//
//  ViewController.swift
//  SegueActionReview
//
//  Created by Yaroslav Bondar on 29.01.2024.
//

import UIKit

/*
 TODO
 pass through nav controller
 tabBar https://useyourloaf.com/blog/using-@ibsegueaction-with-tab-bar-controllers/
 unwind segue
 UIStoryboardUnwindSegueSource
 full exa,ple: func showPreview(coder: NSCoder, sender: Any?, segueIdentifier: String?)

 
 INFO
 _initFromSB
 xib init
 xib in storyboard
 */



/**
 Init from storyboard without optional properties
 
 @IBSegueAction - Storyboard Dependency Injection
 p.s. you can find `UIIBDependencyInjectionInternal` from `Thread.callStackSymbols` inside implementation of any`@IBSegueAction func`
 
 
 iOS 13 / macOS 10.15 / Xcode 11 introduced @IBSegueAction https://useyourloaf.com/blog/better-storyboards-with-xcode-11/
 Better dependency injection for Storyboards in iOS13 https://sarunw.com/posts/better-dependency-injection-for-storyboards-in-ios13/
