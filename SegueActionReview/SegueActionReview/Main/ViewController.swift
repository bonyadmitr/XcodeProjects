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
 
 old way:
 ```
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? TextController, let text = sender as? String {
        vc.text = text
    }
 }
 ```
 
 new way: (without optional `.text`)
 ```
 @IBSegueAction private func onShowText(_ coder: NSCoder, text: String) -> UIViewController? {
    TextController(coder: coder, text: text)
 }
 ```
 
 --- Comparing IBSegueAction vs prepare(for:sender:)
 Here are the advantages of using IBSegueAction:
 * Cleaner code: Each segue can have its own IBSegueAction, resulting in code that is easier to design and maintain.
 * No switching on string constants: prepare(for:sender:) requires you to switch on segue.identifier values that can get out of sync with the identifier properties in the storyboard file.
 * Better encapsulation: The properties can now be private since the value can be set by the initializer and not after initialization inprepare(for:sender:).
 * Immutability: The required properties can be let constants when appropriate since the value is set by the initializer.
 * Less casting: There’s no need to cast the sender.destination to an EditNoteViewController to configure its properties. You create an instance of the view controller type you need.
 * Easier to test: Since you are not relying on UIKit to create your view controller instances, it will be much easier to create tests for your view controllers.
 Disadvantage:
 * It is only available for iOS 13 or later
 https://www.kodeco.com/9296192-improving-storyboard-segues-with-ibsegueaction/page/2
 * @IBSegueAction with Tab Bar Controllers https://useyourloaf.com/blog/using-@ibsegueaction-with-tab-bar-controllers/ + You can use @IBSegueAction with relationship segue by binding relationship segue to a presentation view controller (The view controller that presented navigation controller). (or container view for UITabBarController)
