    @IBAction private func sharedClose() {
        /// short version `navigationController != nil ? _ = navigationController?.popViewController(animated: true) : dismiss(animated: true)`
        if let navigationController {
#if DEBUG
            let vcs = navigationController.viewControllers
            let vcsCount = vcs.count
            if vcsCount >= 2 {
                print("close pop from: \(String(describing: type(of: vcs[vcsCount - 1]))), to: \(String(describing: type(of: vcs[vcsCount - 2])))")
            } else {
                print("sharedClose pop no action")
            }
#endif
            navigationController.popViewController(animated: true)
            
        } else {
#if DEBUG
            if let presentingViewController {
                print("sharedClose dismiss from: \(String(describing: type(of: self))), to: \(String(describing: type(of: presentingViewController)))")
            } else {
                print("sharedClose dismiss no action")
            }
#endif
            /// doc `presentingViewController?.dismiss(animated: true)`
            dismiss(animated: true)
        }
    }
