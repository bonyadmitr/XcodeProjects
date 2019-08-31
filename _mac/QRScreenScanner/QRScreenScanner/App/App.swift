import Cocoa

/// clear app
/// https://stackoverflow.com/a/42013661
/// https://stackoverflow.com/a/55435241

// TODO: dock manager
// TODO: https://stackoverflow.com/a/9220857/5893286
// TODO: https://stackoverflow.com/a/50832237/5893286 + https://stackoverflow.com/a/4686782/5893286
// TODO: https://developer.apple.com/library/archive/technotes/tn2083/_index.html

// TODO: handle cmd+h and cmd+m for window
// TODO: menu for empty tableview
// TODO: more actions in edit menu
// TODO: feedback button

// TODO: view bases tableview
// TODO: delete button in table
// TODO: multiline text

// TODO: clear controller

// TODO: Quick Alert nothing found
// TODO: Add contact from qr
// TODO: Icon
// TODO: Status icon

final class App {
    
    static let shared = App()
    
    let statusItemManager = StatusItemManager()
    let menuManager = MenuManager()
    let toolbarManager = ToolbarManager()
    let windowsManager = WindowsManager()
    
    func start() {
        menuManager.setup()
        statusItemManager.setup()
        toolbarManager.addToWindow(windowsManager.window)
        
        /// set after window.toolbar set.
        //windowsManager.window.hideToolbarCustomizationPaletteItems = true
        
        showWindow()
    }
    
    func showWindow() {
        windowsManager.showWindow()
    }
}

extension App {
    static let id = Bundle.main.bundleIdentifier.assert(or: "")
    static let name = (Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String).assert(or: "")
    static let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).assert(or: "")
    static let build = (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).assert(or: "")
    static let versionWithBuild = "\(version) (\(build))"
    
    private static let githubProjectPath = "https://github.com/bonyadmitr/XcodeProjects/"
    
    static func openSubmitFeedbackPage() {
        let feedbackBody =
        """
        <!--
        Provide your feedback here. Include as many details as possible.
        You can also email me at bonyadmitr@gmail.com
        -->
        
        ---
        \(App.name) \(App.versionWithBuild)
        macOS \(System.osVersion)
        \(System.hardwareModel)
        """
        
        guard
            let encodedBody = feedbackBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            /// can be added title: "&title=\(title)"
            let url = URL(string: "\(githubProjectPath)issues/new?body=\(encodedBody)")
        else {
            assertionFailure()
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
    static func openReleaseNotes() {
        guard let url = URL(string: "\(githubProjectPath)releases") else {
            assertionFailure()
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    /// Feedback and Bugs
    static func openIssues() {
        guard let url = URL(string: "\(githubProjectPath)issues") else {
            assertionFailure()
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
    static func openDocumentation() {
        guard let url = URL(string: "\(githubProjectPath)wiki") else {
            assertionFailure()
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
}
