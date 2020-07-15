// swiftlint:disable all
/// Created by Bondar Yaroslav on 11/15/19.
/// NOT in the project target.
/// .swift due to comment syntax highlighting.


// TODO: a lot of:
/**
 CODE (Developer or QA can see changes):
 mb undomanager
 newValue.isOpaque = true for all possible views
 
 clear code
 debug floating window
 add main.swift
 mb more asserts
 DI
 protocols for view-model
 add ".xcconfig" files
 logging
 fastlane
 kingfisher cache limit
 CoreDataStack start guard
 there is breaking constraint on system cell preview with UIAction. maybe there is a way to fix it
 also cell preview not fit the text
 more UIAppearance + AppearanceManager
 
 REQUIRED FEATURES (User can see changes):
 context menu (UIContextMenuInteractionDelegate)
 save sorting on restart
 error presenting (mb ToastController later(+UIPresentationController) or scrolling several errors)
 error handling (+ InternalError)
 list empty state (+ maybe refresh button)
 internet restoration (wifi + mobile) (list and detail requests, cells resetup with failed images)
 http requests canceling
 split controller
 app restoration
 several windows by SceneDelegate
 localization (+ RTL)
 app rater
 Large Title nav bar
 accessibility (voice, big fonts, mb colors)
 
 ADDITIONAL FEATURES:
 self sizing cells layout
 custom layout (for photos only + mb grid/list) (maybe by UICollectionViewCompositionalLayout)
 layouts changing
 animated layout changing
 tvOS support (didUpdateFocus, dark mode for tvOS)
 shortcuts (UIKeyCommand)
 app extensions (widget(today), file provider(files))
 background updates
 share items
 spotlight (CoreSpotlight)
 siri shotcuts
 crashlytics
 any analitica
 settings screen (+ tab bar if need) (icon, version, feedback, app review...) (for more need to check Settings project)
 settings bundle
 theme switching manualy
 localization switching manualy
 iMessage App
 local notifications (to check updates)
 passcode (+ TouchID and FaceID)
 vibrations on touch
 sounds on touch
 tutorials spotlight
 onboarding screens
 check new updates
 "whats new" screen
 Parallax Effect with UIMotionEffect (for background)
 external screen support
 translucent nav bar (+ fix all scrolls)
 mb something for NaturalLanguage + Create ML
 image recognition
 handoff (opened detail)
 macCatalyst
 macCatalyst Menu Bar article https://www.zachsim.one/blog/2019/8/4/customising-the-menu-bar-of-a-catalyst-app-using-uimenubuilder
 
 DONE:
 swift package manager
 cleared MVC (by separate view, services)
 items list
 item detail
 landscape
 ScaledHeightImageView
 typealias
 Alamofire helpers
 Decodable helpers (FailableDecodable + keyPath)
 image caching by Kingfisher
 used xibs and code for layout (AutoLayout + mask)
 scroll + no scroll layout (detail screen)
 asserts
 UICollectionViewDiffableDataSource + NSDiffableDataSourceSnapshot
 - latest ios (13) for new API
 URLSession cache disabled
 pull to refresh
 activityIndicator for network
 cache by core data for offline using
 searchController
 sorting by ScopeButtons
 collection sections in sorting
 typealias for Model/Cell in view/vc
 remove storyboard (save LaunchScreen only)
 router for navigation (+ mb window manager)
 swiftlint
 unit tests
 UI tests
 mb any scripts or automatization (like fastlane, swiftgen, ...)
 
 layout by three ways: frame (TitleSupplementaryView), autoresizingMask (ProductsListView), IB constraints (ImageTextCell)
 + commented code of anchor constraints (ProductsListView)
 
 CLEARED CODE:
 private
 let
 names
 headers
 constants (for magic numbers)
 willSet
 safe code (less '!')
 there are a lot of commented code for comments or can be usefull in the future (like in the CoreDataStack)
 
 THERE IS NO:
 keychain
 push notifications
 Auth 2
 keyaboard handlers
 pagination
 sync background actions with server
 pass photo to detail screen (bcz there is no bigger image)
 
 
 SOME COMMENTS:
 it is possible to create namspace.
 but will not be possible to use "extension ProductsListController: UICollectionViewDelegate"
 //enum ProductsList {
 //    final class Controller
 //    final class View
 //    final class Interactor
 //}
 
 demo mode without server + without internet (save some jsons to the bundle)
 (can be used json-server https://github.com/typicode/json-server
 or new mocker https://habr.com/ru/company/surfstudio/blog/477506/
 or another way: https://infinum.com/the-capsized-eight/easy-way-to-implement-demo-mode-in-ios-apps
 with https://github.com/AliSoftware/OHHTTPStubs)
 
 custom schemes & universal links
 + try tests by https://github.com/mattstanford/GhostHand
 
 try local/push notifications test by https://medium.com/@mds6058/push-notification-ui-testing-41bf66bed3fa
 */



/// another MVC
/// source https://github.com/JonFir/JMVC
/// Live-coding https://www.youtube.com/watch?v=sM-AaI32hTc
/// video list https://www.youtube.com/channel/UCz0ktLk0st8W9i3qsB5__Iw/videos
