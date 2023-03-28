
extension CATransaction {
    
    private static func setup(_ handler: () -> Void) {
        begin()
        handler()
        commit()
    }
    
    /// inspired https://stackoverflow.com/a/54784013/5893286
    static func disableAnimations(_ handler: () -> Void) {
        setup {
            setDisableActions(true)
            handler()
        }
    }
    
}

