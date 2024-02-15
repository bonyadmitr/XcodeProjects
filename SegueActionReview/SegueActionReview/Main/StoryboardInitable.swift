protocol StoryboardInitable: UIViewController {
    static func _initFromStoryboard <T: UIViewController>(storyboardName: String?, identifier: String?, bundle: Bundle?, _ creator: @escaping ((NSCoder) -> T?)) -> T?
}
