    
    //@IBSegueAction private func onShowTextCell(_ coder: NSCoder, sender: UITableViewCell) -> UIViewController? {
    //    let text = sender.textLabel?.text ?? "nil"
    //    return TextController(coder: coder, text: text)
    //}
    
    @IBSegueAction private func onShowText(_ coder: NSCoder, text: String) -> UIViewController? {
        TextController(coder: coder, text: text)
    }
    
    @IBSegueAction private func onSUIText(_ coder: NSCoder, sender: UITableViewCell) -> UIViewController? {
        let text = sender.textLabel?.text ?? "nil"
        return SwiftUIView(text: text).hostingController(coder: coder)
    }

    
