    
    //@IBSegueAction private func onShowTextCell(_ coder: NSCoder, sender: UITableViewCell) -> UIViewController? {
    //    let text = sender.textLabel?.text ?? "nil"
    //    return TextController(coder: coder, text: text)
    //}
    
    @IBSegueAction private func onShowText(_ coder: NSCoder, text: String) -> UIViewController? {
        TextController(coder: coder, text: text)
    }
    
