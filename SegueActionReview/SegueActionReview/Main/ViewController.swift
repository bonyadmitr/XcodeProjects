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
 
 
 !!! will NOT be called without `super.performSegue(withIdentifier: identifier, sender: sender)` in `override func performSegue(withIdentifier identifier: String, sender: Any?)`.
 `override func performSegue(withIdentifier identifier: String, sender: Any?)` called BEFORE `@IBSegueAction`
 `override func performSegue(withIdentifier identifier: String, sender: Any?)` will be called for manual `performSegue(withIdentifier: "ID", sender: nil)`, NOT for view based segues
 
 `override func prepare(for segue: UIStoryboardSegue, sender: Any?)` called AFTER `@IBSegueAction`
 will be called without `super.prepare(for: segue, sender: sender)` in `override func prepare(for segue: UIStoryboardSegue, sender: Any?)`
 
 if `@IBSegueAction func ... { return nil }` than will be called `required init?(coder: NSCoder)` that we don't want to implement.
 It does not prevent the segue from happening. so use `if/guard` + `performSegue(withIdentifier: "ID", sender: text)` for optionals
 
 `@IBSegueAction` can be and should be `private`
 
 NSObject in storyboard is not working - called `required init?(coder: NSCoder)`
 
 Inheritance for UIViewController is working
 
 
 not working: `convenience required init?(coder: NSCoder) { self.init(coder: coder, text: "") }
 console: `-[<SegueActionReview.ViewController: 0x109606ff0> onShowTextClear:sender:] returned nil, falling back to -[_TtC17SegueActionReview14TextController initWithCoder:]`
 crash: `Terminating app due to uncaught exception 'NSGenericException', reason: 'This coder is expecting the replaced object 0x109621b40 to be returned from UIClassSwapper.initWithCoder instead of <SegueActionReview.TextController: 0x109d07480>'`
 
 
 `super.init(nibName: nil, bundle: nil)` not working for Storyboard. only for xib. so use `StoryboardInitable`
 ```
 init(text: String) {
     self.text = text
     super.init(nibName: nil, bundle: nil)
 }
 ```
 
 apple doc is only in Xcode 11 Release Notes https://developer.apple.com/documentation/xcode-release-notes/xcode-11-release-notes
 */

/*
 Swift 5.1 also allows us to omit the `return`
 
 use SwiftGen for safe segue identifiers in `performSegue(withIdentifier: "showText", sender: text)` like `perform(segue: StoryboardSegue.Message.embed)` https://github.com/SwiftGen/SwiftGen
 */


/*
 Nib injection
 если хочется чтобы была навигация по несколько контроллеров в одном сториборде, но версать экраны разным людям, то можно вынести вьюху в xib
 
 !!! Storyboard ID should be empty + remove view from controller in storyboard
 
 Unwind segue пропадут при переносе
 */



//final class RootController: UIViewController {
//    @IBSegueAction private func onShowTextRoot(_ coder: NSCoder) -> UIViewController? {
//        TextNibController(coder: coder, text: "from root")
//    }
//}

internal class BaseController: UIViewController {
    @IBSegueAction private func onShowTextInheritance(_ coder: NSCoder) -> UIViewController? {
        TextController(coder: coder, text: "from Inheritance")
    }
}

final class ViewController: BaseController {
    
    // MARK: - Segue
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
        print("performSegue: \(identifier), sender: \(sender ?? "nil")")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("prepare(for segue id: \(segue.identifier ?? "nil"), from: \(String(describing: type(of: segue.source))), to: \(String(describing: type(of: segue.destination)))")//, sender: \(sender ?? "nil")")
    }
    
    // MARK: - @IBSegueAction
    
    @IBSegueAction private func showTextMinSegue(_ coder: NSCoder) -> UIViewController? {
        /// not working `UINavigationController(rootViewController: TextController(coder: coder, text: "showTextMinSegue")!)`
        TextController(coder: coder, text: "showTextMinSegue")
    }
    
    @IBSegueAction private func showTextStringSegue(_ coder: NSCoder, text: String) -> UIViewController? {
        TextController(coder: coder, text: text)
    }

    @IBSegueAction private func showTextAnySegue(_ coder: NSCoder, sender: Any?) -> UIViewController? {
        TextController(coder: coder, text: sender as? String ?? "from button showTextAnySegue")
    }
    
    @IBSegueAction private func showTextFull(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> TextController? {
        guard let text = sender as? String ?? (sender as? UIButton)?.title(for: .normal) else {
            assertionFailure()
            return nil
        }
        guard let vc = TextController(coder: coder, text: text) else {
            assertionFailure()
            return nil
        }
        return vc
    }
    
    @IBSegueAction private func onSUItext(_ coder: NSCoder) -> UIViewController? {
        SwiftUIView(text: "onSUItext").hostingController(coder: coder)
    }
    
    @IBSegueAction private func showNavBarText(_ coder: NSCoder) -> UIViewController? {
        TextNibController(coder: coder, text: "showNavBarText 111")
    }
    
    // MARK: - @IBAction
    
    @IBAction private func onPerformSegue() {
        performSegue(withIdentifier: "showText", sender: "showTextStringSegue / performSegue")
    }
    
    @IBAction private func onInitFromStoryboard() {
        let vc = TextController.initFromStoryboard(text: "onInitFromStoryboard")
        present(vc, animated: true)
    }
    
    @IBAction private func onNibCode() {
        let vc = TextNibController(text: "onNibCode")
        present(vc, animated: true)
    }
    
}



extension Array {
    func lastUnsafe(_ offset: Int = 0) -> Element {
        self[count - 1 - offset]
    }
    func last(_ offset: Int) -> Element? {
        let count = self.count
        if offset < count {
            return self[count - 1 - offset]
        }
        return nil
    }
}





/*
 let nib = UINib(nibName: "TextController.storyboardc/TextController", bundle: .main)
 let q = nib.instantiate(withOwner: nil, options: [.externalObjects: ["text": text]])
 
 https://developer.limneos.net/?ios=11.1.2&framework=UIKit.framework&header=UINibDecoder.h
 */

/*
 #0    0x000000010c8eeba6 in TextController.init(coder:text:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/ViewController.swift:69
 #1    0x000000010c8edf7a in TextController.__allocating_init(coder:text:) ()
 #2    0x000000010c8ee1a0 in ViewController.onShowTextClear(_:sender:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/ViewController.swift:41
 #3    0x000000010c8ee20a in @objc ViewController.onShowTextClear(_:sender:) ()
 #4    0x00007ff80563d5e7 in -[UIClassSwapper performSelectorForObject:selector:withObject:withObject:withObject:] ()
 #5    0x00007ff80563db32 in -[UIClassSwapper initWithCoder:] ()
 #6    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #7    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #8    0x00007ff805645940 in -[UIRuntimeConnection initWithCoder:] ()
 #9    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #10    0x00007ff804ad39ce in UINibDecoderDecodeObjectForValue ()
 #11    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #12    0x00007ff80563d06b in -[NSCoder(UIIBDependencyInjectionInternal) _decodeObjectsWithSourceSegueTemplate:creator:sender:forKey:] ()
 #13    0x00007ff80563fd70 in -[UINib instantiateWithOwner:options:] ()
 #14    0x00007ff805dc278f in -[UIStoryboard __reallyInstantiateViewControllerWithIdentifier:creator:storyboardSegueTemplate:sender:] ()
 #15    0x00007ff805dc2634 in -[UIStoryboard _instantiateViewControllerWithIdentifier:creator:storyboardSegueTemplate:sender:] ()
 #16    0x00007ff805dbfb24 in -[UIStoryboardViewControllerPlaceholder initWithCoder:] ()
 #17    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #18    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #19    0x00007ff805645963 in -[UIRuntimeConnection initWithCoder:] ()
 #20    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #21    0x00007ff804ad39ce in UINibDecoderDecodeObjectForValue ()
 #22    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #23    0x00007ff80563d06b in -[NSCoder(UIIBDependencyInjectionInternal) _decodeObjectsWithSourceSegueTemplate:creator:sender:forKey:] ()
 #24    0x00007ff80563fd70 in -[UINib instantiateWithOwner:options:] ()
 #25    0x00007ff805dc278f in -[UIStoryboard __reallyInstantiateViewControllerWithIdentifier:creator:storyboardSegueTemplate:sender:] ()
 #26    0x00007ff805dc2634 in -[UIStoryboard _instantiateViewControllerWithIdentifier:creator:storyboardSegueTemplate:sender:] ()
 #27    0x00007ff805dc3f5a in -[UIStoryboardSegueTemplate instantiateOrFindDestinationViewControllerWithSender:] ()
 #28    0x00007ff805dc4134 in -[UIStoryboardSegueTemplate _perform:] ()
 #29    0x00007ff8051e7def in -[UIViewController performSegueWithIdentifier:sender:] ()
 #30    0x000000010c8ee2e5 in ViewController.onMain() at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/ViewController.swift:48
 #31    0x000000010c8ee32c in @objc ViewController.onMain() ()
 #32    0x00007ff805bc1661 in -[UIApplication sendAction:to:from:forEvent:] ()
 #33    0x00007ff80524971b in -[UIControl sendAction:to:forEvent:] ()
 #34    0x00007ff805249b10 in -[UIControl _sendActionsForEvents:withEvent:] ()
 #35    0x00007ff805245b70 in -[UIButton _sendActionsForEvents:withEvent:] ()
 #36    0x00007ff805249b6c in -[UIControl _sendActionsForEvents:withEvent:] ()
 #37    0x00007ff805245b70 in -[UIButton _sendActionsForEvents:withEvent:] ()
 #38    0x00007ff8052483a1 in -[UIControl touchesEnded:withEvent:] ()
 #39    0x00007ff805c04ea9 in -[UIWindow _sendTouchesForEvent:] ()
 #40    0x00007ff805c07015 in -[UIWindow sendEvent:] ()
 #41    0x00007ff805bdc010 in -[UIApplication sendEvent:] ()
 #42    0x00007ff805c8a6b7 in __dispatchPreprocessedEventFromEventQueue ()
 #43    0x00007ff805c8cf74 in __processEventQueue ()
 #44    0x00007ff805c82bbe in __eventFetcherSourceCallback ()
 #45    0x00007ff8003f8283 in __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ ()
 #46    0x00007ff8003f81c5 in __CFRunLoopDoSource0 ()
 #47    0x00007ff8003f79c2 in __CFRunLoopDoSources0 ()
 #48    0x00007ff8003f20f7 in __CFRunLoopRun ()
 #49    0x00007ff8003f197d in CFRunLoopRunSpecific ()
 #50    0x00007ff80fe9d08f in GSEventRunModal ()
 #51    0x00007ff805bbb53d in -[UIApplication _run] ()
 #52    0x00007ff805bbffab in UIApplicationMain ()
 #53    0x00007ff804c50ea3 in UIApplicationMain(_:_:_:_:) ()
 #54    0x000000010c8f134b in static UIApplicationDelegate.main() ()
 #55    0x000000010c8f12c7 in static AppDelegate.$main() ()
 
 
 
 
 
 
 
 ---------------------
 UINib(nibName: "TextController.storyboardc/TextController", bundle: .main).instantiate(withOwner: nil, options: [.externalObjects: ["text": text]])
 
 
 #0    0x000000010786dd1c in TextController.init(coder:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/ViewController.swift:78
 #1    0x000000010786de48 in @objc TextController.init(coder:) ()
 #2    0x00007ff80563df1a in -[UIClassSwapper initWithCoder:] ()
 #3    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #4    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #5    0x00007ff805645940 in -[UIRuntimeConnection initWithCoder:] ()
 #6    0x00007ff804ad37c4 in UINibDecoderDecodeObjectForValue ()
 #7    0x00007ff804ad39ce in UINibDecoderDecodeObjectForValue ()
 #8    0x00007ff804ad34f2 in -[UINibDecoder decodeObjectForKey:] ()
 #9    0x00007ff80563d06b in -[NSCoder(UIIBDependencyInjectionInternal) _decodeObjectsWithSourceSegueTemplate:creator:sender:forKey:] ()
 #10    0x00007ff80563fd70 in -[UINib instantiateWithOwner:options:] ()
 #11    0x000000010786d737 in TextController.init(text:) at /Users/yaroslav.bondar/Downloads/SegueActionReview/SegueActionReview/ViewController.swift:61
 
 */


// TODO: PopupSegue
//final class SomeSegue: UIStoryboardSegue {
//    override func perform() {
//        print("SomeSegue")
//    }
//}

/*
 class SetMenuSegue: UIStoryboardSegue {
    override func perform() {
        
        guard let menuController = source as? MenuDoubleController else {
            fatalError("container is not MenuDoubleController subclass")
        }
        if identifier == "left" {
            menuController.add(child: destination, to: menuController.leftContainer)
        } else if identifier == "right" {
            menuController.add(child: destination, to: menuController.rightContainer)
        } else if identifier == "main" {
            menuController.viewController = destination
        } else {
            fatalError("segue identifier is not 'right' or 'left'")
        }
    }
}
 
 
 
 import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    
    override func awakeFromNib() {
        performSegue(withIdentifier: "main", sender: nil)
        performSegue(withIdentifier: "left", sender: nil)
        super.awakeFromNib()
    }
}

class SetMenuSegue: UIStoryboardSegue {
    override func perform() {
        
        guard let slideMenuController = source as? SlideMenuController else {
            fatalError("container is not SlideMenuController subclass")
        }
        if identifier == "main" {
            slideMenuController.mainViewController = destination
        } else if identifier == "left" {
            slideMenuController.leftViewController = destination
        } else {
            fatalError("segue identifier is not 'main' or 'left'")
        }
    }
}

