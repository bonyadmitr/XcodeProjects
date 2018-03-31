## BackButtonHandler

```swift
extension ViewController: BackButtonHandler {
    func shouldPopOnBackButton(_ handler: @escaping BoolHandler) {
        let vc = UIAlertController(title: "Exit without save?", message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            handler(true)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            handler(false)
        }
        vc.addAction(yesAction)
        vc.addAction(noAction)
        present(vc, animated: true, completion: nil)
    }
}
```