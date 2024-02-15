protocol StoryboardInitable: UIViewController {
    static func _initFromStoryboard <T: UIViewController>(storyboardName: String?, identifier: String?, bundle: Bundle?, _ creator: @escaping ((NSCoder) -> T?)) -> T?
}
extension StoryboardInitable {
    static func _initFromStoryboard <T: UIViewController>(storyboardName: String? = nil, identifier: String? = nil, bundle: Bundle? = nil, _ creator: @escaping ((NSCoder) -> T?)) -> T? {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: T.self), bundle: bundle)
        if let identifier {
            return storyboard.instantiateViewController(identifier: identifier, creator: creator)
        } else {
            return storyboard.instantiateInitialViewController(creator: creator)
        }
    }
}
